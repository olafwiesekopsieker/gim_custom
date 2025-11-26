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
        SalesShipmentHeader: record "Sales Shipment Header";
    begin
        IF CoS.FINDSET() THEN
            repeat
                case Cos."Document Type" of
                    cos."Document Type"::"Sales Shipment":
                        begin
                            ;
                            if SalesShipmentHeader.get() then begin
                                Cos.gimAuftragsnummer := salesshipmentHeader."Order No.";
                                Cos.modify;
                            end;

                        END;
                end;
            until Cos.next = 0;

    end;

    procedure BackfillInvoiceNoFromShipment()
    var
        CoS: Record "Certificate of Supply";
        SalesInvLine: Record "Sales Invoice Line";
        ServInvLine: Record "Service Invoice Line";
    begin
        if CoS.FindSet() then
            repeat
                // if CoS."Geb. Rechnungsnr." <> '' then
                //     continue;

                case CoS."Document Type" of
                    CoS."Document Type"::"Sales Shipment":
                        begin
                            SalesInvLine.Reset();
                            SalesInvLine.SetRange("Order No.", CoS."gimAuftragsnummer");
                            SalesInvLine.SetCurrentKey("Posting Date", "Document No.", "Line No.");
                            SalesInvLine.SetAscending("Posting Date", false); // jüngste Rechnung zuerst
                            if SalesInvLine.FindFirst() then begin
                                CoS.Validate("Geb. Rechnungsnr.", SalesInvLine."Document No.");
                                CoS.Modify(true); // triggert UpdateDerivedFields()
                            end else begin
                                CoS.Validate("Geb. Rechnungsnr.", '');
                                CoS.Modify(true); // triggert UpdateDerivedFields()
                            end;
                        end;

                    CoS."Document Type"::"Service Shipment":
                        begin
                            ServInvLine.Reset();
                            ServInvLine.SetRange("Order No.", CoS."gimAuftragsnummer");
                            ServInvLine.SetCurrentKey("Posting Date", "Document No.", "Line No.");
                            ServInvLine.SetAscending("Posting Date", false);
                            if ServInvLine.FindFirst() then begin
                                CoS.Validate("Geb. Rechnungsnr.", ServInvLine."Document No.");
                                CoS.Modify(true);
                            end else begin
                                CoS.Validate("Geb. Rechnungsnr.", '');
                                CoS.Modify(true); // triggert UpdateDerivedFields()
                            end;
                        end;
                end;
            until CoS.Next() = 0;
    end;



}

