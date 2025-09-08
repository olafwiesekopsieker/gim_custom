tableextension 80005 IssuedReminderLine extends "Issued Reminder Line"
{
    fields
    {
        field(50081; "Verkäufercode RE"; Code[20])
        {
            Caption = 'Verkäufercode Rechnung';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Salesperson Code" where("No." = FIELD("Document No.")));
        }
        field(50082; "Verkäufercode GU"; Code[20])
        {
            Caption = 'Verkäufercode Gutschrift';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Salesperson Code" where("No." = FIELD("Document No.")));
        }
        field(50083; "Verkäufercode SV"; Code[20])
        {
            Caption = 'Verkäufercode Service';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Invoice Header"."Salesperson Code" where("No." = FIELD("Document No.")));
        }
        field(50084; "Reminder Level"; Integer)
        {
            Caption = 'Mahnstufe';
            FieldClass = FlowField;
            CalcFormula = lookup("Issued Reminder Header"."Reminder Level" where("No." = FIELD("Reminder No.")));
        }
    }
}