pageextension 80042 "gimServiceOrders2" extends "Service Orders"
{
    trigger OnOpenPage()
    var
        ServiceSecurity: Codeunit "gimServiceSecurity";
    begin
        ServiceSecurity.ApplyTechnicianFilter(Rec);
    end;
}