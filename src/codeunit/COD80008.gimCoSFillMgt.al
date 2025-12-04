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
        SalesShipmentHeader: Record "Sales Shipment Header";
        ServiceShipmentHeader: Record "Service Shipment Header";
    begin
        CoS.Reset();
        CoS.SetRange("gimAuftragsnummer", '');
        if CoS.FindSet() then
            repeat
                case CoS."Document Type" of
                    CoS."Document Type"::"Sales Shipment":
                        if SalesShipmentHeader.Get(CoS."Document No.") then begin
                            CoS.Validate("gimAuftragsnummer", SalesShipmentHeader."Order No.");
                            CoS.Modify(true);
                        end;

                    CoS."Document Type"::"Service Shipment":
                        if ServiceShipmentHeader.Get(CoS."Document No.") then begin
                            CoS.Validate("gimAuftragsnummer", ServiceShipmentHeader."Order No.");
                            CoS.Modify(true);
                        end;
                end;
            until CoS.Next() = 0;
    end;


    // =========================================================
    // 6) BACKFILL: Gebuchte Rechnungsnr. nachziehen (Bestand)
    // =========================================================
    procedure BackfillInvoiceNo()
    var
        CoS: Record "Certificate of Supply";
        CoS2: Record "Certificate of Supply";
        SalesInvLine: Record "Sales Invoice Line";
        ServInvHeader: Record "Service Invoice Header";
    begin
        CoS.Reset();
        CoS.SetRange("Geb. Rechnungsnr.", '');
        if CoS.FindSet() then
            repeat
                CoS2 := CoS;

                case CoS."Document Type" of
                    // SALES SHIPMENT → nach Shipment No. suchen
                    CoS."Document Type"::"Sales Shipment":
                        begin
                            SalesInvLine.Reset();
                            SalesInvLine.SetRange("Shipment No.", CoS2."Document No.");
                            SalesInvLine.SetCurrentKey("Posting Date", "Document No.", "Line No.");
                            SalesInvLine.SetAscending("Posting Date", false); // jüngste Rechnung zuerst

                            if SalesInvLine.FindFirst() then begin
                                CoS2.Validate("Geb. Rechnungsnr.", SalesInvLine."Document No.");
                                CoS2.Modify(true);
                            end;
                        end;

                    // SERVICE SHIPMENT → wie gehabt über Order No. (oder analog umbauen)
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



}

