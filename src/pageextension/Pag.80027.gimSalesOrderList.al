pageextension 80027 "SalesOrderList Ext. Etagis" extends "Sales Order List"
{
    layout
    {
        // Position nach Bedarf anpassen (z. B. addlast(repeater) oder addafter("Shipment Date"))
        addafter("Shipment Date")
        {
            field("Planned Shipment Date Min (etagis)"; Rec."Plan Shipm. Date Min (etagis)")
            {
                ApplicationArea = All;
                Caption = 'Gepl. Warenausgang (min, etagis)';
                ToolTip = 'Kleinstes geplantes Warenausgangsdatum aus den Zeilen (etagis).';

            }
            field("Planned Shipment Date Max (etagis)"; Rec."Plan Shipm. Date Max (etagis)")
            {
                ApplicationArea = All;
                Caption = 'Gepl. Warenausgang (max, etagis)';
                ToolTip = 'Größtes geplantes Warenausgangsdatum aus den Zeilen (etagis).';

            }
            field("Status (etagis)"; Rec."Status (etagis)")
            {
                ApplicationArea = All;
                Caption = 'Status (etagis)';
                ToolTip = 'Aggregierter (kritischster) Etagis-Status des Auftrags.';
                Style = Strong;
                StyleExpr = StatusStyleTxt;
            }
            field("gimAvailabilityStatus"; Rec."gimAvailabilityStatus")
            {
                ApplicationArea = All;
                Caption = 'Verfügbarkeit';
                ToolTip = 'Verfügbarkeitsstatus (Fertigware)';
                Style = Strong;
                StyleExpr = AvailabilityStyleTxt;
            }
        }
    }


    actions
    {
        addlast(processing)
        {
            action(RefreshAvailability)
            {
                ApplicationArea = All;
                Caption = 'Verfügbarkeit aktualisieren (Fertigware)';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindSet() then
                        repeat
                            SalesHeader.UpdateEtagisStatus(); // Updates both dates and availability
                        until SalesHeader.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        StatusStyleTxt: Text[30];
        AvailabilityStyleTxt: Text[30];

    trigger OnAfterGetRecord()
    begin
        StatusStyleTxt := GetStatusStyle(Rec."Status (etagis)");
        AvailabilityStyleTxt := GetAvailabilityStyle(Rec."gimAvailabilityStatus");
    end;

    local procedure GetStatusStyle(Status: Option Unkritisch,Ungeplant,Kritisch): Text
    begin
        case Status of
            Status::Unkritisch:
                exit('Favorable'); // grün
            Status::Ungeplant:
                exit('Ambiguous'); // neutral
            Status::Kritisch:
                exit('Attention'); // rot/gelb
        end;
        exit('');
    end;

    local procedure GetAvailabilityStyle(Status: Option "Incomplete","Partially Available","Fully Available"): Text
    begin
        case Status of
            Status::"Fully Available":
                exit('Favorable'); // Green
            Status::"Partially Available":
                exit('Ambiguous'); // Yellow/Grey
            Status::"Incomplete":
                exit('Attention'); // Red
        end;
        exit('');
    end;
}