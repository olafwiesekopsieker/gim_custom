codeunit 80009 "gimCoSSubscribers"
{
    // =========================================================
    // 1) SALES SHIPMENT → CoS erzeugen (für Nicht-EU)
    //    EU-Fälle werden vom Standard angelegt – wir hooken nur an.
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure CreateCoSFromSalesShipment(var Rec: Record "Sales Shipment Header"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
        CountryRegion: Record "Country/Region";
        ShipToCountry: Code[10];
    begin
        // EU-Erkennung (Sales)
        ShipToCountry := Rec."Ship-to Country/Region Code";
        if ShipToCountry = '' then
            ShipToCountry := Rec."Bill-to Country/Region Code";

        if (ShipToCountry <> '') and CountryRegion.Get(ShipToCountry) then
            if CountryRegion."EU Country/Region Code" <> '' then
                exit; // EU-Fälle macht der Standard → danach wird OnAfterInsert(T780) ausgeführt

        // Nicht-EU → CoS per Standard-Funktion erzeugen
        CoS.InitFromSales(Rec);
    end;



    // =========================================================
    // 2) SERVICE SHIPMENT → CoS erzeugen (für Nicht-EU)
    //    EU-Fälle übernimmt euer System bereits → kein doppeltes Anlegen.
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Service Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure CreateCoSFromServiceShipment(var Rec: Record "Service Shipment Header"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
        CountryRegion: Record "Country/Region";
        ShipToCountry: Code[10];
    begin
        // EU-Erkennung (Service)
        ShipToCountry := Rec."Ship-to Country/Region Code";
        if ShipToCountry = '' then
            ShipToCountry := Rec."Bill-to Country/Region Code";

        if (ShipToCountry <> '') and CountryRegion.Get(ShipToCountry) then
            if CountryRegion."EU Country/Region Code" <> '' then
                exit; // EU → bereits im System erzeugt

        // Nicht-EU → eigene Init-Funktion
        CoS.InitFromService(Rec);
    end;



    // =========================================================
    // 3) CoS AFTER INSERT (SALES + SERVICE)
    //    → Auftragsnummer
    //    → Verkäufer / Versand durch DÜSI (via gimCoSFillMgt)
    //    (gilt für EU & Nicht-EU)
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Certificate of Supply", 'OnAfterInsertEvent', '', true, true)]
    local procedure CoS_OnAfterInsert(var Rec: Record "Certificate of Supply"; RunTrigger: Boolean)
    var
        SalesShp: Record "Sales Shipment Header";
        ServShp: Record "Service Shipment Header";
        CoSFillMgt: Codeunit "gimCoSFillMgt";
    begin
        case Rec."Document Type" of

            Rec."Document Type"::"Sales Shipment":
                if SalesShp.Get(Rec."Document No.") then begin
                    if Rec."gimAuftragsnummer" = '' then
                        Rec.Validate("gimAuftragsnummer", SalesShp."Order No.");

                    CoSFillMgt.FillFromSources(Rec);
                    Rec.Modify(true);
                end;

            Rec."Document Type"::"Service Shipment":
                if ServShp.Get(Rec."Document No.") then begin
                    if Rec."gimAuftragsnummer" = '' then
                        Rec.Validate("gimAuftragsnummer", ServShp."Order No.");

                    CoSFillMgt.FillFromSources(Rec);
                    Rec.Modify(true);
                end;
        end;
    end;



    // =========================================================
    // 4) RECHNUNGEN (SALES + SERVICE)
    //    Geb. Rechnungsnr. anhand Shipment No. setzen
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





}
