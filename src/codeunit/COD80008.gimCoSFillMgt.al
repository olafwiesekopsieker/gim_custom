codeunit 80008 "gimCoSFillMgt"
{
    procedure FillFromSources(var CoS: Record "Certificate of Supply")
    var
        SalesInv: Record "Sales Invoice Header";
        SalesShp: Record "Sales Shipment Header";
        SalesHdr: Record "Sales Header";
        ServInv: Record "Service Invoice Header";
        ServShp: Record "Service Shipment Header";
        ServHdr: Record "Service Header";
    begin
        // Ziel-Felder nur ergänzen, nicht blind überschreiben
        if (CoS."Versand durch DÜSI" = '') or (CoS."Verkäufercode 1" = '') or (CoS."Verkäufercode 2" = '') then begin
            case CoS."Document Type" of
                CoS."Document Type"::"Sales Shipment":
                    begin
                        // 1) Gebuchte Rechnung
                        if (CoS."Geb. Rechnungsnr." <> '') and SalesInv.Get(CoS."Geb. Rechnungsnr.") then begin
                            if CoS."Versand durch DÜSI" = '' then
                                CoS."Versand durch DÜSI" := SalesInv."Shipping Agent Code";
                            if CoS."Verkäufercode 1" = '' then
                                CoS."Verkäufercode 1" := SalesInv."Salesperson Code";
                            if CoS."Verkäufercode 2" = '' then
                                CoS."Verkäufercode 2" := salesinv."Salesperson Code 2";
                            exit;
                        end;

                        // 2) Gebuchte Lieferung (neueste zu Order)
                        if CoS."gimAuftragsnummer" <> '' then begin
                            SalesShp.Reset();
                            SalesShp.SetRange("Order No.", CoS."gimAuftragsnummer");
                            SalesShp.SetCurrentKey("Posting Date", "No.");
                            SalesShp.SetAscending("Posting Date", false); // neueste zuerst
                            if SalesShp.FindFirst() then begin
                                if CoS."Versand durch DÜSI" = '' then
                                    CoS."Versand durch DÜSI" := SalesShp."Shipping Agent Code";
                                if CoS."Verkäufercode 1" = '' then
                                    CoS."Verkäufercode 1" := SalesShp."Salesperson Code";
                                if CoS."Verkäufercode 2" = '' then
                                    CoS."Verkäufercode 2" := SalesShp."CCS DM Salesperson Code 2";
                                exit;
                            end;
                        end;

                        // 3) Auftrag
                        if (CoS."gimAuftragsnummer" <> '') and
                           SalesHdr.Get(SalesHdr."Document Type"::Order, CoS."gimAuftragsnummer") then begin
                            if CoS."Verkäufercode 1" = '' then
                                CoS."Verkäufercode 1" := SalesHdr."Salesperson Code";
                            if CoS."Verkäufercode 2" = '' then
                                CoS."Verkäufercode 2" := SalesHdr."Salesperson Code 2";
                        end;
                    end;

                CoS."Document Type"::"Service Shipment":
                    begin
                        // 1) Gebuchte Service-Rechnung
                        if (CoS."Geb. Rechnungsnr." <> '') and ServInv.Get(CoS."Geb. Rechnungsnr.") then begin
                            if CoS."Versand durch DÜSI" = '' then
                                CoS."Versand durch DÜSI" := ServInv."Shipping Agent Code";
                            if CoS."Verkäufercode 1" = '' then
                                CoS."Verkäufercode 1" := ServInv."Salesperson Code";
                            if CoS."Verkäufercode 2" = '' then
                                CoS."Verkäufercode 2" := ServInv."Service Salesperson Code";
                            exit;
                        end;

                        // 2) Gebuchte Service-Lieferung
                        if CoS."gimAuftragsnummer" <> '' then begin
                            ServShp.Reset();
                            ServShp.SetRange("Order No.", CoS."gimAuftragsnummer");
                            ServShp.SetCurrentKey("Posting Date", "No.");
                            ServShp.SetAscending("Posting Date", false);
                            if ServShp.FindFirst() then begin
                                if CoS."Versand durch DÜSI" = '' then
                                    CoS."Versand durch DÜSI" := ServShp."Shipping Agent Code";
                                if CoS."Verkäufercode 1" = '' then
                                    CoS."Verkäufercode 1" := ServShp."Salesperson Code";
                                if CoS."Verkäufercode 2" = '' then
                                    CoS."Verkäufercode 2" := ServShp."CCS DM Salesperson Code 2";
                                exit;
                            end;
                        end;

                        // 3) Service-Auftrag
                        if (CoS."gimAuftragsnummer" <> '') and
                           ServHdr.Get(ServHdr."Document Type"::Order, CoS."gimAuftragsnummer") then begin
                            if CoS."Verkäufercode 1" = '' then
                                CoS."Verkäufercode 1" := ServHdr."Salesperson Code";
                            if CoS."Verkäufercode 2" = '' then
                                CoS."Verkäufercode 2" := ServHdr."Service Salesperson Code";
                        end;
                    end;
            end;
        end;
    end;



}

