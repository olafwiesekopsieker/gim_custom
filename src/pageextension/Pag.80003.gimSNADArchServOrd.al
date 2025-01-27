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
                    SO: record "MUL SNAD Arch Serv. Header";
                begin
                    SO.setrange("Document Type", rec."Document Type");
                    SO.setrange("No.", rec."No.");
                    if SO.FINDLast() then
                        repChecklistForArchSO.SetTableView(so);
                    repChecklistForArchSO.run;


                end;
            }
        }
    }
}
