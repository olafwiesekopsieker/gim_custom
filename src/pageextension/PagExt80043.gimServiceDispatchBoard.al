pageextension 80043 "gimServiceDispatchBoard" extends "Dispatch Board"
{
    trigger OnOpenPage()
    var
        ServiceSecurity: Codeunit "gimServiceSecurity";
        ServiceHeader: Record "Service Header";
    begin
        // Da das Dispatch Board Service Header verwendet, wende den Filter an
        ServiceSecurity.ApplyTechnicianFilter(ServiceHeader);
        // Aber da die Seite komplex ist, könnte ein direkter Filter auf die Seite nötig sein
        // Für Einfachheit: Setze einen globalen Filter
    end;
}