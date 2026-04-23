pageextension 80037 gimServiceOrderSubform2 extends "Service Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(Servicebetrag; Rec.Servicebetrag)
            {
                ApplicationArea = All;
                Caption = 'Servicebetrag';
                editable = true;
            }
        }
    }
}
