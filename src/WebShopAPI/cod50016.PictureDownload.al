codeunit 80001 "gim2DownloadImageToItem"
{
    trigger OnRun()
    var
        Item: Record Item;
        ErrorText: Text;
        ProcessedCount: Integer;
        ErrorCount: Integer;
    begin
        // Filter: nur die gewünschten Artikel
        Item.SetFilter("Gen. Prod. Posting Group", '%1|%2', 'FERTIGWA19', 'HANDELWA19');

        if Item.FindSet() then
            repeat
                ProcessedCount += 1;

                if not GetItemMetadataSafe(Item."No.", ErrorText) then begin
                    ErrorCount += 1;
                    LogItemError(Item."No.", ErrorText);
                end;
            until Item.Next() = 0;

        // Wenn du willst, kannst du hier noch eine Message ausgeben,
        // aber bei Job Queue eher NICHT:
        // Message('Fertig. Artikel: %1, Fehler: %2.', ProcessedCount, ErrorCount);
    end;

    // ==================================================================
    //  BILDER – HARTE VERSION
    // ==================================================================

    /// Öffentliche, fehlertolerante Hülle. Bricht die Schleife nicht ab.
    procedure GetItemMetadataSafe(ItemNo: Code[30]; var ErrorText: Text): Boolean
    begin
        ErrorText := '';

        if GetItemMetadataInternal(ItemNo) then
            exit(true);

        ErrorText := GetLastErrorText();
        exit(false);
    end;

    /// TryFunction: Fehler hier drin werden nicht propagiert, sondern via GetLastErrorText abgeholt.
    [TryFunction]
    local procedure GetItemMetadataInternal(ItemNo: Code[30])
    var
        PictureUrl: Text;
    begin
        // Aktuell: Direktes Bild aus PIM, ohne JSON
        PictureUrl := 'https://pim.dueperthal.com/showMainImage/%1';
        PictureUrl := StrSubstNo(PictureUrl, ItemNo);

        ImportItemPictureFromURL(ItemNo, PictureUrl);
    end;

    /// Bild von URL holen, sauber prüfen, ins Artikelbild schreiben.
    procedure ImportItemPictureFromURL(ItemNo: Code[30]; PictureURL: Text)
    var
        Item: Record Item;
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        if (ItemNo = '') or (PictureURL = '') then
            error('Ungültige Parameter für ImportItemPictureFromURL. ItemNo=%1, URL=%2', ItemNo, PictureURL);

        // HTTP-Request
        if not Client.Get(PictureURL, Response) then
            error('Bild-Download für Artikel %1 fehlgeschlagen. Die URL konnte nicht aufgerufen werden: %2',
                  ItemNo, PictureURL);

        // HTTP-Status prüfen
        if not Response.IsSuccessStatusCode() then
            error('Bild-Download für Artikel %1 fehlgeschlagen. HTTP-Status: %2. URL: %3',
                  ItemNo, Response.HttpStatusCode(), PictureURL);

        // Inhalt in Stream lesen
        Response.Content.ReadAs(InStr);

        if not Item.Get(ItemNo) then
            error('Artikel %1 für Bild-Download nicht gefunden.', ItemNo);

        Clear(Item.Picture);
        Item.Picture.ImportStream(InStr, 'Bild für Artikel ' + Item."No.");
        Item.Modify(true);
    end;

    // ==================================================================
    //  PDF-Teil (so wie bei dir, nur leicht gestrafft & gehärtet)
    // ==================================================================

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

    // ==================================================================
    //  Logging-Helfer
    // ==================================================================

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