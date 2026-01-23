pageextension 80497 "gimReservationEntries" extends "Reservation Entries"
{
    layout
    {
        addafter("Source ID")
        {
            field("gimAvailabilityStatus"; AvailabilityStatus)
            {
                ApplicationArea = All;
                Caption = 'Verfügbarkeit (Auftrag)';
                ToolTip = 'Zeigt den Verfügbarkeitsstatus des zugehörigen Verkaufsauftrags an.';
                Style = Strong;
                StyleExpr = AvailabilityStyleTxt;
                Editable = false;
            }
        }
    }

    var
        AvailabilityStatus: Option "Incomplete","Partially Available","Fully Available";
        AvailabilityStyleTxt: Text[30];

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        ClearStatus();

        // Check if Source is Sales Order (Type 37, Subtype 1 = Order)
        if (Rec."Source Type" = 37) and (Rec."Source Subtype" = 1) then begin
            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Source ID") then begin
                AvailabilityStatus := SalesHeader."gimAvailabilityStatus";
                AvailabilityStyleTxt := GetAvailabilityStyle(AvailabilityStatus);
            end;
        end;
    end;

    local procedure ClearStatus()
    begin
        AvailabilityStatus := AvailabilityStatus::Incomplete;
        AvailabilityStyleTxt := '';
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
