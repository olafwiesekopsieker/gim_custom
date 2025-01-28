pageextension 80003 gimSNADArchServOrd extends "MUL SNAD Arch Serv. O."
{
    layout
    {

    }
    actions
    {
        addlast(Order)
        {
            action(Pruefzertifikat)
            {
                caption = 'Prüfzertifikat für Arch. Serv. Auftr.';
                ApplicationArea = all;

                trigger OnAction()
                var
                    repChecklistForArchSO: report "gimCheck List for Archived";
                    SOL: record "MUL SNAD Arch Serv. item Line";
                begin
                    SOL.setrange("Document Type", rec."Document Type");
                    SOL.setrange("Document No.", rec."No.");
                    if SOl.FINDLast() then
                        repChecklistForArchSO.SetTableView(sol);
                    repChecklistForArchSO.run;


                end;
            }
        }
    }
}
