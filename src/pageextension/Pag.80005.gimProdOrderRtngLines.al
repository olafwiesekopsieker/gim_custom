pageextension 80005 gimProdOrderRtngLines extends "Prod. Order Routing"
{
    layout
    {
        addafter("Ending Date-Time")
        {
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
