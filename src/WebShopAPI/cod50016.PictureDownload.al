codeunit 80001 "gim2DownloadImageToItem"
{
    trigger OnRun()
    var
        Item: Record Item;
        ProcessedCount: Integer;
        ErrorCount: Integer;
        ErrorText: Text;
        Success: Boolean;
    begin
        // Filter: nur relevante Artikel
        Item.SetFilter("Gen. Prod. Posting Group", '%1|%2', 'FERTIGWA19', 'HANDELWA19');

        if Item.FindSet() then
            repeat
                ProcessedCount += 1;

                Success := DownloadItemPictureSafe(Item."No.", ErrorText);

                if not Success then begin
                    ErrorCount += 1;
                    LogItemError(Item."No.", ErrorText);
                end;
            until Item.Next() = 0;

        // Wenn du das über die Job Queue laufen lässt, lass die Message weg.
        // Für einmalig direkt aus der Oberfläche starten kannst du sie zum Test aktivieren:
        // Message('Bild-Download abgeschlossen. Artikel: %1, Fehler: %2.', ProcessedCount, ErrorCount);
    end;

    // =========================================================
    //  BILDER – KEINE error(), nur Rückgabewerte & Logging
    // =========================================================

    procedure DownloadItemPictureSafe(ItemNo: Code[30]; var ErrorText: Text): Boolean
    var
        PictureUrl: Text;
    begin
        ErrorText := '';

        if ItemNo = '' then begin
            ErrorText := 'Leere Artikelnummer.';
            exit(false);
        end;

        PictureUrl := 'https://pim.dueperthal.com/showMainImage/%1';
        PictureUrl := StrSubstNo(PictureUrl, ItemNo);

        exit(ImportItemPictureFromURLNoError(ItemNo, PictureUrl, ErrorText));
    end;

    /// Bild importieren, aber **niemals error() werfen**.
    /// Stattdessen: false + ErrorText zurückgeben.
    procedure ImportItemPictureFromURLNoError(ItemNo: Code[30]; PictureURL: Text; var ErrorText: Text): Boolean
    var
        Item: Record Item;
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
        Ok: Boolean;
    begin
        ErrorText := '';

        if (ItemNo = '') or (PictureURL = '') then begin
            ErrorText := StrSubstNo('Ungültige Parameter. ItemNo=%1, URL=%2', ItemNo, PictureURL);
            exit(false);
        end;

        // HTTP-Request
        Ok := Client.Get(PictureURL, Response);
        if not Ok then begin
            ErrorText := StrSubstNo(
                'Bild-Download fehlgeschlagen. URL konnte nicht aufgerufen werden: %1',
                PictureURL);
            exit(false);
        end;

        // HTTP-Status prüfen
        if not Response.IsSuccessStatusCode() then begin
            ErrorText := StrSubstNo(
                'Bild-Download fehlgeschlagen. HTTP-Status: %1. URL: %2',
                Response.HttpStatusCode(), PictureURL);
            exit(false);
        end;

        // Inhalt in Stream lesen
        Response.Content.ReadAs(InStr);

        if not Item.Get(ItemNo) then begin
            ErrorText := StrSubstNo('Artikel %1 nicht gefunden.', ItemNo);
            exit(false);
        end;

        Clear(Item.Picture);
        Item.Picture.ImportStream(InStr, 'Bild für Artikel ' + Item."No.");
        Item.Modify(true);

        exit(true);
    end;

    // =========================================================
    //  PDF-Teil – unverändert / optional
    //  (Wenn du hier auch „nicht crashen“ willst, machen wir das genauso)
    // =========================================================

    procedure ExportPDF(ItemNo: Code[30])
    var
        Item: Record Item;
        TenantMedia: Record "Tenant Media";
        Ins: InStream;
        Filename: Text;
    begin
        if not Item.Get(ItemNo) then
            exit;

        if Item.gimTechDatasheet.Count = 0 then
            exit;

        if TenantMedia.Get(Item.gimTechDatasheet.Item(1)) then begin
            TenantMedia.CalcFields(Content);
            if TenantMedia.Content.HasValue then begin
                Filename := 'TechDatasheet ' + ItemNo + '.pdf';
                TenantMedia.Content.CreateInStream(Ins);
                DownloadFromStream(Ins, '', '', '', Filename);
            end;
        end;
    end;

    procedure ImportPDFFromURL(ItemNo: Code[30]; LanguageCode: Text[10]; PDFType: Integer)
    var
        Item: Record Item;
        Client: HttpClient;
        PDFURL: Text;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        // Wenn du auch hier „nicht crashen“ willst → gleiche Strategie wie bei den Bildern
        if LanguageCode = '' then begin
            PDFURL := 'https://pim.dueperthal.com/downloadDatasheet/%1';
            PDFURL := StrSubstNo(PDFURL, ItemNo);
        end else begin
            PDFURL := 'https://pim.dueperthal.com/downloadDatasheet/%1?lang=%2';
            PDFURL := StrSubstNo(PDFURL, ItemNo, LowerCase(LanguageCode));
        end;

        if not Client.Get(PDFURL, Response) then
            error('Datenblatt-Download für Artikel %1 fehlgeschlagen. URL nicht erreichbar: %2', ItemNo, PDFURL);

        if not Response.IsSuccessStatusCode() then
            error('Datenblatt-Download für Artikel %1 fehlgeschlagen. HTTP-Status: %2. URL: %3',
                  ItemNo, Response.HttpStatusCode(), PDFURL);

        Response.Content.ReadAs(InStr);

        if not Item.Get(ItemNo) then
            error('Artikel %1 für Datenblattimport nicht gefunden.', ItemNo);

        Clear(Item.gimTechDatasheet);
        Item.gimTechDatasheet.ImportStream(
            InStr,
            'Technisches Datenblatt ' + Format(Item."No."),
            'application/pdf');
        Item.Modify(true);
    end;

    // =========================================================
    //  Logging-Helfer (nur Telemetrie, keine Ausnahme)
    // =========================================================

    local procedure LogItemError(ItemNo: Code[30]; ErrorText: Text)
    begin
        Session.LogMessage(
            'gimIMGERR',
            StrSubstNo('Fehler beim Verarbeiten von Artikel %1: %2', ItemNo, ErrorText),
            Verbosity::Warning,
            DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher,
            'ItemNo', ItemNo);
    end;
}