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
            field("LEAD Nummer"; Rec."LEAD Nummer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the LEAD Number.';
            }
        }
        addlast("Shipping and Billing")
        {
            // field("fix-Termin Lieferung"; Rec."fix-Termin Lieferung")
            // {
            //     ApplicationArea = All;
            // }
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
        addafter("Shipment Date")
        {
            group("Etagis – Planung")
            {
                Caption = 'Etagis – Planung';
                field("Planned Shipm. Date Min (etagis)"; rec."Plan Shipm. Date Min (etagis)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Kleinstes geplantes Warenausgangsdatum aus den Zeilen (etagis).';
                }
                field("Planned Shipm. Date Max (etagis)"; rec."Plan Shipm. Date Max (etagis)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Größtes geplantes Warenausgangsdatum aus den Zeilen (etagis).';
                }
                field("Status (etagis)"; rec."Status (etagis)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Aggregierter (kritischster) Etagis-Status des Auftrags.';
                    Style = Strong;
                    StyleExpr = HeaderStatusStyleTxt;
                }
            }
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
        HeaderStatusStyleTxt: Text[30];

    local procedure IsCustBlocked(): Boolean
    begin
        rec.CalcFields(Blocked);
        exit(Rec.Blocked <> Enum::"Customer Blocked"::" ");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CustomerIsBlocked := IsCustBlocked();
    end;

    trigger OnAfterGetRecord()
    begin
        HeaderStatusStyleTxt := GetStatusStyle(rec."Status (etagis)");
    end;

    local procedure GetStatusStyle(Status: Option Unkritisch,Ungeplant,Kritisch): Text
    begin
        case Status of
            Status::Unkritisch:
                exit('Favorable');   // grün
            Status::Ungeplant:
                exit('Ambiguous');   // grau/neutral
            Status::Kritisch:
                exit('Attention');   // rot/gelb
        end;
        exit('');
    end;
}
