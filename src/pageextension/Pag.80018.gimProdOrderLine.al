pageextension 80024 gimProdOrderLine extends "Prod. Order Line List"
{
    layout
    {
        addafter("Ending Time")
        {
            field("etagis Data"; Rec."etagis Data")
            {
                ApplicationArea = all;
                editable = false;
            }
            field(Produktionszieltermin; Rec.Produktionszieltermin)
            {
                ApplicationArea = all;

            }
            field(gimEingeplanteStartzeit; Rec.gimEingeplanteStartzeit)
            {
                ApplicationArea = all;
            }
            field(gimEingeplanteEndzeit; Rec.gimEingeplanteEndzeit)
            {
                ApplicationArea = all;
            }
        }

    }
}
