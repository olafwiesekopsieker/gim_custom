pageextension 80005 gimPurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {
        addfirst(PurchDetailLine)
        {
            field(Position; Rec.Position)
            {
                ApplicationArea = all;
            }
        }

    }

}
