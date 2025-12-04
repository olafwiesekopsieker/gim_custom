codeunit 80009 "gimCoSSubscribers"
{
    // Management für Certificate of Supply:
    // - Sales/Service Shipment (Nicht-EU): CoS beim Buchen erzwingen
    // - Sales/Service Shipment (EU): CoS kommt aus Standard/anderer Logik
    // - Immer: Auftragsnr. & Zusatzfelder bei CoS-Insert
    // - Immer: Geb. Rechnungsnr. bei Rechnungszeilen
    // - Backfill für Altbestand

    // =========================================================
    // 1) SALES SHIPMENT: CoS nur für Nicht-EU erzwingen
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure CreateCoSOnSalesShipmentInsert(var Rec: Record "Sales Shipment Header"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
        CountryRegion: Record "Country/Region";
        ShipToCountry: Code[10];
    begin
        // EU-Erkennung
        ShipToCountry := Rec."Ship-to Country/Region Code";
        if ShipToCountry = '' then
            ShipToCountry := Rec."Bill-to Country/Region Code";

        if (ShipToCountry <> '') and CountryRegion.Get(ShipToCountry) then
            if CountryRegion."EU Country/Region Code" <> '' then
                exit; // EU: Standard/andere Logik erzeugt CoS → hier nichts anlegen

        // Nur Nicht-EU: eigenen CoS anlegen, falls keiner existiert
        CoS.Reset();
        CoS.SetRange("Document Type", CoS."Document Type"::"Sales Shipment");
        CoS.SetRange("Document No.", Rec."No.");
        if CoS.FindFirst() then
            exit; // es gibt schon einen

        CoS.Init();
        CoS."Document Type" := CoS."Document Type"::"Sales Shipment";
        CoS."Document No." := Rec."No.";
        CoS.Insert(true); // OnAfterInsert(T780) übernimmt Auftragsnr. & Zusatzfelder
    end;


    // =========================================================
    // 2) SERVICE SHIPMENT: CoS nur für Nicht-EU erzwingen
    // =========================================================
    [EventSubscriber(ObjectType::Table, Database::"Service Shipment Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure CreateCoSOnServiceShipmentInsert(var Rec: Record "Service Shipment Header"; RunTrigger: Boolean)
    var
        CoS: Record "Certificate of Supply";
        CountryRegion: Record "Country/Region";
        ShipToCountry: Code[10];
    begin
        // EU-Erkennung
        ShipToCountry := Rec."Ship-to Country/Region Code";
        if ShipToCountry = '' then
            ShipToCountry := Rec."Bill-to Country/Region Code";

        if (ShipToCountry <> '') and CountryRegion.Get(ShipToCountry) then
            if CountryRegion."EU Country/Region Code" <> '' then
                exit; // EU: CoS kommt aus Standard/anderer Logik

        // Nur Nicht-EU: eigenen CoS anlegen, falls keiner existiert
        CoS.Reset();
        CoS.SetRange("Document Type", CoS."Document Type"::"Service Shipment");
        CoS.SetRange("Document No.", Rec."No.");
        if CoS.FindFirst() then
            exit;

        CoS.Init();
        CoS."Document Type" := CoS."Document Type"::"Service Shipment";
        CoS."Document No." := Rec."No.";
        CoS.Insert(true); // OnAfterInsert(T780) macht den Rest
    end;

    // =========================================================
    // 3) CoS-INSERT: Auftragsnr. + Zusatzfelder IMMER nachziehen
    //    (Standard + Erweiterung, EU + Nicht-EU)
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
                begin
                    if SalesShp.Get(Rec."Document No.") then begin
                        if Rec."gimAuftragsnummer" = '' then
                            Rec.Validate("gimAuftragsnummer", SalesShp."Order No.");

                        // Verkäufer, Versand durch DÜSI etc.
                        CoSFillMgt.FillFromSources(Rec);
                        Rec.Modify(true);
                    end;
                end;

            Rec."Document Type"::"Service Shipment":
                begin
                    if ServShp.Get(Rec."Document No.") then begin
                        if Rec."gimAuftragsnummer" = '' then
                            Rec.Validate("gimAuftragsnummer", ServShp."Order No.");

                        CoSFillMgt.FillFromSources(Rec);
                        Rec.Modify(true);
                    end;
                end;
        end;
    end;


    // =========================================================
    // 4) RECHNUNG: Geb. Rechnungsnr. beim Buchen setzen
    //    (Sales Invoice Line / Service Invoice Line, EU + Nicht-EU)
    // =========================================================
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
                    CoS.Modify(true);
                end;
            until CoS.Next() = 0;
    end;



}
