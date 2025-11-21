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



}

