codeunit 80008 "gimCoSFillMgt"
{
    procedure FillFromSources(var CoS: Record "Certificate of Supply")
    var
        SalesShp: Record "Sales Shipment Header";
        ServShp: Record "Service Shipment Header"; // ggf. Namespace anpassen
    begin
        Case Cos."Document Type" of
            Cos."Document Type"::"Sales Shipment":
                begin
                    if SalesShp.Get(CoS."Document No.") then begin

                        // Verkäufercode
                        //if CoS."Verkäufercode 1" = '' then
                        CoS."Verkäufercode 1" := SalesShp."Salesperson Code";

                        //if CoS."Verkäufercode 2" = '' then
                        CoS."Verkäufercode 2" := SalesShp."CCS DM Salesperson Code 2";

                        // Versand durch DÜSI
                        //if CoS."Versand durch DÜSI" = '' then
                        CoS."Versand durch DÜSI" := SalesShp."Shipping Agent Code";
                    end;
                end;

            CoS."Document Type"::"Service Shipment":
                if ServShp.Get(CoS."Document No.") then begin
                    //if CoS."Verkäufercode 1" = '' then
                    CoS."Verkäufercode 1" := ServShp."Salesperson Code";
                    //if CoS."Verkäufercode 2" = '' then
                    CoS."Verkäufercode 2" := ServShp."CCS DM Salesperson Code 2";
                    //if CoS."Versand durch DÜSI" = '' then
                    CoS."Versand durch DÜSI" := ServShp."Shipping Agent Code"; // falls vorhanden
                end;
        end;


    end;

    // =========================================================
    // 5) BACKFILL: Auftragsnummer nachziehen (Bestand)
    // =========================================================
    procedure BackfillOrderNo()
    var
        CoS: Record "Certificate of Supply";
        SalesShp: Record "Sales Shipment Header";
        ServShp: Record "Service Shipment Header";
    begin
        CoS.Reset();
        CoS.SetRange("gimAuftragsnummer", '');
        if CoS.FindSet() then
            repeat
                case CoS."Document Type" of

                    CoS."Document Type"::"Sales Shipment":
                        if SalesShp.Get(CoS."Document No.") then begin
                            CoS.Validate("gimAuftragsnummer", SalesShp."Order No.");
                            CoS.Modify(true);
                        end;

                    CoS."Document Type"::"Service Shipment":
                        if ServShp.Get(CoS."Document No.") then begin
                            CoS.Validate("gimAuftragsnummer", ServShp."Order No.");
                            CoS.Modify(true);
                        end;
                end;
            until CoS.Next() = 0;
    end;



    // =========================================================
    // 6) BACKFILL: Gebuchte Rechnungsnummer über Shipment No.
    // =========================================================
    procedure BackfillInvoiceNo()
    var
        CoS: Record "Certificate of Supply";
        CoS2: Record "Certificate of Supply";
        SalesInvLine: Record "Sales Invoice Line";
        ServInvHeader: Record "Service Invoice Header";
    begin
        CoS.Reset();
        CoS.SetFilter("Geb. Rechnungsnr.", '%1', ''); // nur leere verarbeiten

        if CoS.FindSet() then
            repeat
                CoS2 := CoS;

                case CoS."Document Type" of

                    // SALES SHIPMENT → Zuordnung über Shipment No.
                    CoS."Document Type"::"Sales Shipment":
                        begin
                            SalesInvLine.Reset();
                            SalesInvLine.SetRange("Shipment No.", CoS2."Document No.");
                            SalesInvLine.SetCurrentKey("Posting Date", "Document No.", "Line No.");
                            SalesInvLine.SetAscending("Posting Date", false);

                            if SalesInvLine.FindFirst() then begin
                                CoS2.Validate("Geb. Rechnungsnr.", SalesInvLine."Document No.");
                                CoS2.Modify(true);
                            end;
                        end;

                    // SERVICE SHIPMENT → falls Shipment No. gepflegt ist
                    CoS."Document Type"::"Service Shipment":
                        begin
                            // Service Invoice Header hat kein Shipment No., aber
                            // Service Invoice Line hat es → matching analog zu oben:
                            // (Service Invoice Line Subscriber füllt neue Fälle bereits korrekt)

                            // Alternativ: Order No.
                            if CoS2."gimAuftragsnummer" = '' then
                                continue;

                            ServInvHeader.Reset();
                            ServInvHeader.SetRange("Order No.", CoS2."gimAuftragsnummer");
                            if ServInvHeader.FindFirst() then begin
                                CoS2.Validate("Geb. Rechnungsnr.", ServInvHeader."No.");
                                CoS2.Modify(true);
                            end;
                        end;
                end;
            until CoS.Next() = 0;
    end;

    procedure ResetSuspiciousInvoiceNos()
    var
        CoS: Record "Certificate of Supply";
    begin
        CoS.Reset();
        CoS.SetRange("gimAuftragsnummer", '');
        CoS.SetFilter("Geb. Rechnungsnr.", '<>%1', '');
        if CoS.FindSet() then
            repeat
                CoS.Validate("Geb. Rechnungsnr.", ''); // oder direkt: CoS."Geb. Rechnungsnr." := '';
                CoS.Modify(true);
            until CoS.Next() = 0;
    end;

    // =========================================================
    // EINMALIGER REBUILD: fehlende CoS aus gebuchten Lieferscheinen anlegen
    // =========================================================
    procedure RebuildCoSFromPostedShipments()
    var
        SalesShp: Record "Sales Shipment Header";
        ServShp: Record "Service Shipment Header";
        CoS: Record "Certificate of Supply";
    begin
        // 1) Sales Shipments
        SalesShp.Reset();
        if SalesShp.FindSet() then
            repeat
                if not CoS.Get(CoS."Document Type"::"Sales Shipment", SalesShp."No.") then
                    CoS.InitFromSales(SalesShp); // idempotent & standardnah
            until SalesShp.Next() = 0;

        // 2) Service Shipments
        ServShp.Reset();
        if ServShp.FindSet() then
            repeat
                if not CoS.Get(CoS."Document Type"::"Service Shipment", ServShp."No.") then
                    CoS.InitFromService(ServShp); // deine TableExt-Funktion
            until ServShp.Next() = 0;
    end;


    // =========================================================
    // EINMALIGER REBUILD: nur Zeitraum (Posting Date)
    // (hilft, wenn ihr "dazwischen" eingrenzen wollt)
    // =========================================================
    procedure RebuildCoSForPostingDateRange(FromDate: Date; ToDate: Date)
    var
        SalesShp: Record "Sales Shipment Header";
        ServShp: Record "Service Shipment Header";
        CoS: Record "Certificate of Supply";
    begin
        // Sales Shipments
        SalesShp.Reset();
        SalesShp.SetRange("Posting Date", FromDate, ToDate);
        if SalesShp.FindSet() then
            repeat
                if not CoS.Get(CoS."Document Type"::"Sales Shipment", SalesShp."No.") then
                    CoS.InitFromSales(SalesShp);
            until SalesShp.Next() = 0;

        // Service Shipments
        ServShp.Reset();
        ServShp.SetRange("Posting Date", FromDate, ToDate);
        if ServShp.FindSet() then
            repeat
                if not CoS.Get(CoS."Document Type"::"Service Shipment", ServShp."No.") then
                    CoS.InitFromService(ServShp);
            until ServShp.Next() = 0;
    end;


    // =========================================================
    // REPARATUR-LAUF: fehlende Felder in CoS nachziehen
    // =========================================================
    procedure RepairExistingCoS()
    begin
        // Reihenfolge ist wichtig:
        BackfillOrderNo();
        BackfillInvoiceNo();
    end;


}

