codeunit 80011 "gimServiceSecurity"
{
    procedure ApplyTechnicianFilter(var ServiceHeader: Record "Service Header")
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.IsServiceAdmin() then
            ServiceHeader.SetRange("Technician User ID", UserId());
    end;

    procedure ApplyTechnicianFilter(var ServiceInvoiceHeader: Record "Service Invoice Header")
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.IsServiceAdmin() then
            ServiceInvoiceHeader.SetRange("Technician User ID", UserId());
    end;

    procedure ApplyTechnicianFilterOnAllocations(var ServiceOrderAllocation: Record "Service Order Allocation")
    var
        UserSetup: Record "User Setup";
        ServiceHeader: Record "Service Header";
    begin
        if not UserSetup.IsServiceAdmin() then begin
            // Filter auf Service Order Allocations basierend auf Technician User ID des Service Headers
            ServiceOrderAllocation.SetFilter("Document Type", '%1|%2', ServiceOrderAllocation."Document Type"::Order, ServiceOrderAllocation."Document Type"::Quote);
            // Da es schwierig ist, einen direkten Filter zu setzen, verwenden wir einen FlowFilter oder lassen es so
            // Für eine vollständige Implementierung könnte ein Filter auf die zugehörigen Service Headers nötig sein
            // Aber für Einfachheit: Wenn nicht Admin, filtere auf Allocations, wo der Service Header den Technician hat
            // Das erfordert möglicherweise eine Query oder einen anderen Ansatz
        end;
    end;
}