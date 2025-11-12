pageextension 80027 "SalesOrderList Ext. Etagis" extends "Sales Order List"
{
    layout
    {
        // Position nach Bedarf anpassen (z. B. addlast(repeater) oder addafter("Shipment Date"))
        addafter("Shipment Date")
        {
            field("Planned Shipment Date Min (etagis)"; Rec."Planned Shipment Date Min (etagis)")
            {
                ApplicationArea = All;
                Caption = 'Gepl. Warenausgang (min, etagis)';
                ToolTip = 'Kleinstes geplantes Warenausgangsdatum aus den Zeilen (etagis).';

            }
            field("Planned Shipment Date Max (etagis)"; Rec."Planned Shipment Date Max (etagis)")
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
        }
    }

    var
        StatusStyleTxt: Text[30];

    trigger OnAfterGetRecord()
    begin
        StatusStyleTxt := GetStatusStyle(Rec."Status (etagis)");
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
}