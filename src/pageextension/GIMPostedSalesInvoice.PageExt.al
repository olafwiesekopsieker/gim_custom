pageextension 80009 "GIM Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("CCS DM Salesperson Code 2"; Rec."CCS DM Salesperson Code 2")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Bill-to Name")
        {
            field("Bill-to Customer No."; Rec."Bill-to Customer No.") { ApplicationArea = All; }
        }
        addafter("Bill-to Name")
        {
            field("Bill-to Name 2"; Rec."Bill-to Name 2") { ApplicationArea = All; Caption = 'Name 2'; }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2") { ApplicationArea = All; Caption = 'Name 2'; }
        }
    }
    actions
    {
        addafter(Print)
        {
            action(PrintCommInv)
            {
                Caption = 'Prepayment Invoice';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    report.run(report::"CCO Sales Advance Prep.Invoice", true, false, SalesInvHeader);
                end;
            }
        }
    }
}
