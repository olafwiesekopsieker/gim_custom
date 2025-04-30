pageextension 80008 "CCO Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        addlast(General)
        {
            field("Order No."; Rec."Order No.") { ApplicationArea = All; }
            field("Invoice No."; Rec."Invoice No.") { ApplicationArea = All; }
            field("Salesperson Code 2"; Rec."Salesperson Code 2") { ApplicationArea = All; }
        }

        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2") { ApplicationArea = All; Caption = 'Name 2'; }
        }
        addafter("Bill-to Name")
        {
            field("Bill-to Name 2"; Rec."Bill-to Name 2") { ApplicationArea = All; Caption = 'Name 2'; }
        }
        // addafter("Ship-to Name")
        // {
        //     field("Ship-to Name 2"; Rec."Ship-to Name 2") { ApplicationArea = All; Caption = 'Name 2'; }
        // }
    }
    actions
    {
        addlast(Reporting)
        {
            action("CCO Clearance Certificate")
            {
                ApplicationArea = All;
                Caption = 'Clearance Certificate';
                Promoted = true;
                PromotedCategory = Category10;
                PromotedOnly = true;
                Image = PrintDocument;

                trigger OnAction()
                var
                    ClearanceCertificate: Report "CCO Clearance Certificate";
                begin
                    Rec.SetRecFilter();
                    ClearanceCertificate.SetTableView(Rec);
                    ClearanceCertificate.RunModal();
                end;
            }
            action(ReturnSlip)
            {
                Caption = 'Return Slip';
                Image = Print;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin

                    SalesHeader := Rec;
                    SalesHeader.SetRecFilter();
                    Report.Run(REPORT::"CCO Sales Return Shipment", true, false, SalesHeader);
                end;
            }
        }
    }
}
