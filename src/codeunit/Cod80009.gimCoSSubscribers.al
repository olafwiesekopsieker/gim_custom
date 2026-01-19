codeunit 80009 "gimCoSSubscribers"
{
    // Immer CoS sicherstellen (EU + Nicht-EU)
    // Verhindert Dubletten ausschließlich über Get() / Existenzprüfung.

    // =========================================================
    // SALES SHIPMENT → CoS sicherstellen
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure EnsureCoSFromSalesShipment(var Rec: Record "Sales Shipment Header"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
    begin
        // Wenn schon vorhanden (z.B. Standard hat angelegt) → nichts tun
        if CoS.Get(CoS."Document Type"::"Sales Shipment", Rec."No.") then
            exit;

        // Sonst standardnah anlegen (füllt Standardfelder)
        CoS.InitFromSales(Rec);
        // InitFromSales ist ebenfalls idempotent (prüft intern mit Get),
        // aber wir prüfen vorher schon, damit wir ganz sicher sind.
    end;


    // =========================================================
    // SERVICE SHIPMENT → CoS sicherstellen
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Service Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure EnsureCoSFromServiceShipment(var Rec: Record "Service Shipment Header"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
    begin
        if CoS.Get(CoS."Document Type"::"Service Shipment", Rec."No.") then
            exit;

        // Eigene InitFromService (aus TableExtension) nutzt Standard-ähnliche Befüllung
        CoS.gimInitFromService(Rec);
    end;




    // =========================================================
    // CoS AFTER INSERT → Auftragsnr. + Zusatzfelder immer ergänzen
    // (egal ob Standard oder wir angelegt haben)
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Certificate of Supply", 'OnAfterInsertEvent', '', true, true)]
    local procedure CoS_OnAfterInsert(var Rec: Record "Certificate of Supply"; RunTrigger: Boolean)
    var
        SalesShp: Record "Sales Shipment Header";
        ServShp: Record "Service Shipment Header";
        CoSFillMgt: Codeunit "gimCoSFillMgt";
        Modified: Boolean;
    begin
        Modified := false;

        case Rec."Document Type" of
            Rec."Document Type"::"Sales Shipment":
                if SalesShp.Get(Rec."Document No.") then begin
                    if Rec."gimAuftragsnummer" = '' then begin
                        Rec.Validate("gimAuftragsnummer", SalesShp."Order No.");
                        Modified := true;
                    end;

                    CoSFillMgt.FillFromSources(Rec);
                    Modified := true;
                end;

            Rec."Document Type"::"Service Shipment":
                if ServShp.Get(Rec."Document No.") then begin
                    if Rec."gimAuftragsnummer" = '' then begin
                        Rec.Validate("gimAuftragsnummer", ServShp."Order No.");
                        Modified := true;
                    end;

                    CoSFillMgt.FillFromSources(Rec);
                    Modified := true;
                end;
        end;

        if Modified then
            Rec.Modify(true);
    end;


    // =========================================================
    // INVOICE LINES → Geb. Rechnungsnr. anhand Shipment No. setzen
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesInvoiceLine_OnAfterInsert(var Rec: Record "Sales Invoice Line"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
    begin
        if Rec."Shipment No." = '' then
            exit;

        CoS.Reset();
        CoS.SetRange("Document Type", CoS."Document Type"::"Sales Shipment");
        CoS.SetRange("Document No.", Rec."Shipment No.");
        if CoS.FindSet() then
            repeat
                if CoS."Geb. Rechnungsnr." = '' then begin
                    CoS.Validate("Geb. Rechnungsnr.", Rec."Document No.");
                    CoS.Modify(true);
                end;
            until CoS.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Service Invoice Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure ServiceInvoiceLine_OnAfterInsert(var Rec: Record "Service Invoice Line"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
    begin
        if Rec."Shipment No." = '' then
            exit;

        CoS.Reset();
        CoS.SetRange("Document Type", CoS."Document Type"::"Service Shipment");
        CoS.SetRange("Document No.", Rec."Shipment No.");
        if CoS.FindSet() then
            repeat
                if CoS."Geb. Rechnungsnr." = '' then begin
                    CoS.Validate("Geb. Rechnungsnr.", Rec."Document No.");
                    CoS.Modify(true);
                end;
            until CoS.Next() = 0;
    end;


    // =========================================================
    // BACKFILL: Auftragsnummern (Bestand)
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
    // BACKFILL: Geb. Rechnungsnr. (Bestand)
    // Sales: über Shipment No. (robust)
    // Service: fallback über Order No. (wenn nötig)
    // =========================================================
    procedure BackfillInvoiceNo()
    var
        CoS: Record "Certificate of Supply";
        CoS2: Record "Certificate of Supply";
        SalesInvLine: Record "Sales Invoice Line";
        ServInvHeader: Record "Service Invoice Header";
    begin
        CoS.Reset();
        CoS.SetFilter("Geb. Rechnungsnr.", '%1', '');
        if CoS.FindSet() then
            repeat
                CoS2 := CoS;

                case CoS."Document Type" of
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

                    CoS."Document Type"::"Service Shipment":
                        begin
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


}
