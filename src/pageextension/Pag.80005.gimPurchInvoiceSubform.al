pageextension 80005 gimPurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {
        addfirst(content)
        {
            field(Position; Rec.Position)
            {
                ApplicationArea = all;
            }
        }

    }

}
