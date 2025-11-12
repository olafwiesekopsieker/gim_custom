codeunit 80006 "Etagis Backfill"
{
    Subtype = install;

    trigger OnInstallAppPerCompany()
    begin
        BackfillAllOpenSales();
    end;

    local procedure BackfillAllOpenSales()
    var
        Sh: Record "Sales Header";
        Sl: Record "Sales Line";
    begin
        Sh.SetRange("Document Type", Sh."Document Type"::Order);
        // Eingrenzen nach Bedarf (offene Aufträge etc.)
        if Sh.FindSet() then
            repeat
                Sl.SetRange("Document Type", Sh."Document Type");
                Sl.SetRange("Document No.", Sh."No.");
                if Sl.FindSet() then
                    repeat
                        Sl.RecalcEtagisStatusIfNeeded();
                    until Sl.Next() = 0;

                Sh.UpdateEtagisStatus();
            until Sh.Next() = 0;
    end;
}