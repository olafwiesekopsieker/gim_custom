codeunit 80009 "gimCoSSubscribers"
{
    // ==========================
    // SALES SHIPMENT
    // ==========================
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesShipment_OnAfterInsert(var Rec: Record "Sales Shipment Header"; RunTrigger: Boolean)
    begin
        UpdateCoSFromSalesShipment(Rec);
    end;

    local procedure UpdateCoSFromSalesShipment(SalesShp: Record "Sales Shipment Header")
    var
        CoS: Record "Certificate of Supply";
        Modified: Boolean;
    begin
        if SalesShp."No." = '' then
            exit;

        CoS.Reset();
        CoS.SetRange("Document Type", Enum::"Supply Document Type"::"Sales Shipment");
        CoS.SetRange("Document No.", SalesShp."No.");
        if CoS.FindSet(true) then
            repeat
                Modified := false;

                // Auftragsnummer aus Shipment übernehmen, falls leer
                if (CoS."gimAuftragsnummer" = '') and (SalesShp."Order No." <> '') then begin
                    CoS.Validate("gimAuftragsnummer", SalesShp."Order No.");
                    Modified := true;
                end;

                if Modified then
                    CoS.Modify(true);
            until CoS.Next() = 0;
    end;

    // ==========================
    // SERVICE SHIPMENT
    // ==========================
    [EventSubscriber(ObjectType::Table, Database::"Service Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure ServiceShipment_OnAfterInsert(var Rec: Record "Service Shipment Header"; RunTrigger: Boolean)
    begin
        UpdateCoSFromServiceShipment(Rec);
    end;

    local procedure UpdateCoSFromServiceShipment(ServShp: Record "Service Shipment Header")
    var
        CoS: Record "Certificate of Supply";
        Modified: Boolean;
    begin
        if ServShp."No." = '' then
            exit;

        CoS.Reset();
        CoS.SetRange("Document Type", Enum::"Supply Document Type"::"Service Shipment");
        CoS.SetRange("Document No.", ServShp."No.");
        if CoS.FindSet(true) then
            repeat
                Modified := false;

                if (CoS."gimAuftragsnummer" = '') and (ServShp."Order No." <> '') then begin
                    CoS.Validate("gimAuftragsnummer", ServShp."Order No.");
                    Modified := true;
                end;

                if Modified then
                    CoS.Modify(true);
            until CoS.Next() = 0;
    end;

    // ==========================
    // SALES INVOICE
    // ==========================
    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesInvoice_OnAfterInsert(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    begin
        UpdateCoSFromSalesInvoice(Rec);
    end;

    local procedure UpdateCoSFromSalesInvoice(SalesInv: Record "Sales Invoice Header")
    var
        CoS: Record "Certificate of Supply";
        Modified: Boolean;
    begin
        if (SalesInv."No." = '') and (SalesInv."Order No." = '') then
            exit;

        // 1) Per Order No. auf CoS verknüpfen
        CoS.Reset();
        CoS.SetRange("Document Type", Enum::"Supply Document Type"::"Sales Shipment");
        if SalesInv."Order No." <> '' then
            CoS.SetRange("gimAuftragsnummer", SalesInv."Order No.")
        else
            // Fallback: Falls ihr CoS schon direkt auf Rechnungsnr. verknüpft habt
            CoS.SetRange("Geb. Rechnungsnr.", SalesInv."No.");

        if CoS.FindSet(true) then
            repeat
                Modified := false;

                // Gebuchte Rechnungsnr. nachziehen
                if (CoS."Geb. Rechnungsnr." = '') then begin
                    CoS.Validate("Geb. Rechnungsnr.", SalesInv."No.");
                    Modified := true;
                end;

                if Modified then
                    CoS.Modify(true);
            until CoS.Next() = 0;
    end;

    // ==========================
    // SERVICE INVOICE
    // ==========================
    [EventSubscriber(ObjectType::Table, Database::"Service Invoice Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure ServiceInvoice_OnAfterInsert(var Rec: Record "Service Invoice Header"; RunTrigger: Boolean)
    begin
        UpdateCoSFromServiceInvoice(Rec);
    end;

    local procedure UpdateCoSFromServiceInvoice(ServInv: Record "Service Invoice Header")
    var
        CoS: Record "Certificate of Supply";
        Modified: Boolean;
    begin
        if (ServInv."No." = '') and (ServInv."Order No." = '') then
            exit;

        CoS.Reset();
        CoS.SetRange("Document Type", Enum::"Supply Document Type"::"Service Shipment");
        if ServInv."Order No." <> '' then
            CoS.SetRange("gimAuftragsnummer", ServInv."Order No.")
        else
            CoS.SetRange("Geb. Rechnungsnr.", ServInv."No.");

        if CoS.FindSet(true) then
            repeat
                Modified := false;

                if (CoS."Geb. Rechnungsnr." = '') then begin
                    CoS.Validate("Geb. Rechnungsnr.", ServInv."No.");
                    Modified := true;
                end;

                if Modified then
                    CoS.Modify(true);
            until CoS.Next() = 0;
    end;
}
