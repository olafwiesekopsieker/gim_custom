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

    Procedure FillOrderNo()
    var
        CoS: record "Certificate of Supply";
        Cos2: record "Certificate of Supply";
        SalesShipmentHeader: record "Sales Shipment Header";
        ServiceShipmentHeader: record "Service Shipment Header";
    begin
        Cos.Setrange(Cos.gimAuftragsnummer, '');
        IF CoS.FINDSET() THEN
            repeat
                Cos2 := cos;
                case Cos."Document Type" of
                    cos."Document Type"::"Sales Shipment":
                        begin

                            if SalesShipmentHeader.get(Cos."Document No.") then begin
                                Cos2.gimAuftragsnummer := salesshipmentHeader."Order No.";
                                Cos2.modify;
                                commit;
                            end;

                        END;

                    cos."Document Type"::"Service Shipment":
                        begin

                            if ServiceShipmentHeader.get(Cos."Document No.") then begin
                                Cos2.gimAuftragsnummer := ServiceshipmentHeader."Order No.";
                                Cos2.modify;
                                commit;
                            end;

                        END;
                end;
            until Cos.next = 0;

    end;

    procedure BackfillInvoiceNoFromShipment()
    var
        CoS: Record "Certificate of Supply";
        Cos2: Record "Certificate of Supply";
        SalesInvLine: Record "Sales Invoice Line";
        ServInvHeader: Record "Service Invoice Header";
    begin
        cos.setRANGE("Geb. Rechnungsnr.", '');
        if CoS.FindSet() then
            repeat
                // if CoS."Geb. Rechnungsnr." <> '' then
                //     continue;
                cos2 := Cos;
                case CoS."Document Type" of
                    CoS."Document Type"::"Sales Shipment":
                        begin
                            SalesInvLine.Reset();
                            SalesInvLine.SetRange("Order No.", CoS."gimAuftragsnummer");
                            SalesInvLine.SetCurrentKey("Posting Date", "Document No.", "Line No.");
                            SalesInvLine.SetAscending("Posting Date", false); // jüngste Rechnung zuerst
                            if SalesInvLine.FindFirst() then begin
                                CoS2.Validate("Geb. Rechnungsnr.", SalesInvLine."Document No.");
                                CoS2.Modify(true); // triggert UpdateDerivedFields()
                            end else begin
                                CoS2.Validate("Geb. Rechnungsnr.", '');
                                CoS2.Modify(true); // triggert UpdateDerivedFields()
                            end;
                        end;

                    CoS."Document Type"::"Service Shipment":
                        begin
                            ServInvHeader.Reset();
                            ServInvHeader.SetRange("Order No.", CoS."gimAuftragsnummer");
                            if ServInvHeader.FindFirst() then begin
                                CoS.Validate("Geb. Rechnungsnr.", ServInvHeader."No.");
                                CoS2.Modify(true);
                            end else begin
                                CoS.Validate("Geb. Rechnungsnr.", '');
                                CoS2.Modify(true); // triggert UpdateDerivedFields()
                            end;
                        end;
                end;
            //commit;
            until CoS.Next() = 0;
    end;



}

