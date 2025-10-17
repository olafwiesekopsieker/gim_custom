pageextension 80025 gimRelProdOrderLines extends "Released Prod. Order Lines"
{
    layout
    {
        Addafter("Ending Date-Time")
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
