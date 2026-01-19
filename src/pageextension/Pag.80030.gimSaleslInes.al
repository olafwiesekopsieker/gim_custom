pageextension 80030 gimSaleslInes2 extends "Sales Lines 2"
{
    layout
    {
        modify("Qty. to Shipment")
        {
            visible = false;
        }
        addafter(VK2)
        {
            field(gimQtyToInvtPick; Rec.gimQtyToInvtPick)
            {
                applicationArea = all;
            }
            field(gimQtyToPick; Rec.gimQtyToPick)
            {
                applicationArea = all;
            }
            field(gimQtytoPickReg; Rec.gimQtytoPickReg)
            {
                applicationArea = all;
            }
        }
    }
}
