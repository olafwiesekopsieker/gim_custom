pageextension 80010 gimSalesOrder extends "Sales Order"
{

    layout
    {
        modify("Sell-to Customer Name")
        {
            StyleExpr = CustomerIsBlocked;
        }

        addafter("Sell-to Customer No.")
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
        }

        addafter("Assigned User ID")
        {
            field(Zusatzstatus; Rec.Zusatzstatus)
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("No. Printed"; Rec."No. Printed")
            {
                ApplicationArea = All;
            }
            field("Internal Job No."; Rec."Internal Job No.")
            {
                ApplicationArea = All;
            }
            field(Webrequest; Rec.Webrequest)
            {
                ApplicationArea = All;
            }
            field("Zeilenrabatt ausblenden"; Rec."Zeilenrabatt ausblenden")
            {
                ApplicationArea = All;
            }
            field("Pos.-Zus.-Zähl-Summen drucken"; Rec."Pos.-Zus.-Zähl-Summen drucken")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
            field(Wiedervorlage; Rec.Wiedervorlage)
            {
                ApplicationArea = All;
            }
        }
        addlast("Shipping and Billing")
        {
            field("fix-Termin Lieferung"; Rec."fix-Termin Lieferung")
            {
                ApplicationArea = All;
            }
            field(Kundenliefertermin; Rec.Kundenliefertermin)
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
        addlast("&Print")
        {
            action(PackingList)
            {
                Caption = 'Packing List (Shipping)';
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category11;

                trigger OnAction()
                var
                    SalesPackingList: Report "CCO Sales Packing List";
                begin
                    Rec.SetRecFilter();
                    SalesPackingList.SetTableView(Rec);
                    SalesPackingList.RunModal();
                end;
            }
            action(CustomsInvoice)
            {
                Caption = 'Customs Invoice';
                ApplicationArea = All;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Category11;

                trigger OnAction()
                var
                    ReportSelections: Record "Report Selections";
                begin
                    Rec.SetRecFilter();
                    ReportSelections.PrintReport(ReportSelections.Usage::"CCO Customs Trade Invoice", Rec);
                end;
            }
        }
    }

    var
        CustomerIsBlocked: Boolean;

    local procedure IsCustBlocked(): Boolean
    begin
        rec.CalcFields(Blocked);
        exit(Rec.Blocked <> Enum::"Customer Blocked"::" ");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CustomerIsBlocked := IsCustBlocked();
    end;
}
