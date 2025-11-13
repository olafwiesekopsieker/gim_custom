codeunit 80007 "gimCoSInstall"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        RunBackfill();
    end;

    local procedure RunBackfill()
    var
        CoS: Record "Certificate of Supply";
        Modified: Boolean;
        OldVersand, OldVK1, OldVK2 : Code[20];
        BatchSize: Integer;
        Cnt: Integer;
    begin
        BatchSize := 500;

        CoS.SetLoadFields("gimAuftragsnummer", "Geb. Rechnungsnr.", "Versand durch DÜSI",
                          "Verkäufercode 1", "Verkäufercode 2", "Document No.", "Document Type");

        if CoS.FindSet(true, false) then
            repeat
                Modified := false;

                // Alte Werte speichern
                OldVersand := CoS."Versand durch DÜSI";
                OldVK1 := CoS."Verkäufercode 1";
                OldVK2 := CoS."Verkäufercode 2";

                // 1) Auftragsnummer ermitteln (falls leer)
                if (CoS."gimAuftragsnummer" = '') and (CoS."Document No." <> '') then begin
                    AssignOrderNo(CoS);
                    Modified := true;
                end;

                // 2) Rechnungsnr. ermitteln (falls leer)
                if (CoS."Geb. Rechnungsnr." = '') and (CoS."gimAuftragsnummer" <> '') then begin
                    AssignInvoiceNo(CoS);
                    Modified := true;
                end;

                // 3) Nach unten ableiten (wenn durch Validates nicht schon passiert):
                if not Modified then begin
                    // Hier verwenden wir dieselbe Logik:
                    CoS.UpdateDerivedFields();
                end;

                // Prüfen, ob sich systemische Felder geändert haben
                if (CoS."Versand durch DÜSI" <> OldVersand) or
                   (CoS."Verkäufercode 1" <> OldVK1) or
                   (CoS."Verkäufercode 2" <> OldVK2)
                then
                    Modified := true;

                if Modified then begin
                    CoS.Modify(true);
                    Cnt += 1;
                end;

                if Cnt >= BatchSize then begin
                    Commit();
                    Cnt := 0;
                end;
            until CoS.Next() = 0;

        Commit();
    end;

    local procedure AssignOrderNo(var CoS: Record "Certificate of Supply")
    var
        ShpSales: Record "Sales Shipment Header";
        ShpServ: Record "Service Shipment Header";
    begin
        case CoS."Document Type" of
            CoS."Document Type"::"Sales Shipment":
                if ShpSales.Get(CoS."Document No.") then
                    CoS.Validate("gimAuftragsnummer", ShpSales."Order No.");

            CoS."Document Type"::"Service Shipment":
                if ShpServ.Get(CoS."Document No.") then
                    CoS.Validate("gimAuftragsnummer", ShpServ."Order No.");
        end;
    end;

    local procedure AssignInvoiceNo(var CoS: Record "Certificate of Supply")
    var
        InvSales: Record "Sales Invoice Header";
        InvServ: Record "Service Invoice Header";
    begin
        case CoS."Document Type" of
            CoS."Document Type"::"Sales Shipment":
                begin
                    InvSales.SetRange("Order No.", CoS."Auftragsnummer");
                    InvSales.SetCurrentKey("Posting Date");
                    InvSales.SetAscending("Posting Date", false);
                    if InvSales.FindFirst() then
                        CoS.Validate("Geb. Rechnungsnr.", InvSales."No.");
                end;

            CoS."Document Type"::"Service Shipment":
                begin
                    InvServ.SetRange("Order No.", CoS."gimAuftragsnummer");
                    InvServ.SetCurrentKey("Posting Date");
                    InvServ.SetAscending("Posting Date", false);
                    if InvServ.FindFirst() then
                        CoS.Validate("Geb. Rechnungsnr.", InvServ."No.");
                end;
        end;
    end;
}
