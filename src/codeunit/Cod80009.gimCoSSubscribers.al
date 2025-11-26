codeunit 80009 "gimCoSSubscribers"
{
    // ==========================
    // SALES SHIPMENT
    // ==========================
    // ========================================================
    // Shipment → Auftragsnummer (falls gewünscht)
    // ========================================================

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesShipment_OnAfterInsert(var Rec: Record "Sales Shipment Header"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
    begin
        CoS.Reset();
        CoS.SetRange("Document Type", CoS."Document Type"::"Sales Shipment");
        CoS.SetRange("Document No.", Rec."No.");
        if CoS.FindFirst() then begin
            if CoS."gimAuftragsnummer" = '' then begin
                CoS.Validate("gimAuftragsnummer", Rec."Order No.");
                CoS.Modify(true);
            end;
        end;
    end;


    // ========================================================
    // Invoice Lines → Geb. Rechnungsnr. aus Shipment ermitteln
    // ========================================================

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesInvLine_OnAfterInsert(var Rec: Record "Sales Invoice Line"; RunTrigger: Boolean)
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
    local procedure ServInvLine_OnAfterInsert(var Rec: Record "Service Invoice Line"; RunTrigger: Boolean)
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
                    CoS.Modify(true); // UpdateDerivedFields wird mit ausgeführt
                end;
            until CoS.Next() = 0;
    end;
}
