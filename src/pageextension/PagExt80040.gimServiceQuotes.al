pageextension 80040 "gimServiceQuotes" extends "Service Quotes"
{
    trigger OnOpenPage()
    var
        ServiceSecurity: Codeunit "gimServiceSecurity";
    begin
        ServiceSecurity.ApplyTechnicianFilter(Rec);
    end;
}