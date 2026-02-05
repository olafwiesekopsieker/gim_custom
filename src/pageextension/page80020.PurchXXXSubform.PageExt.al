pageextension 80020 gimPurchOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }
    }
}

pageextension 80021 gimPurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }
        addfirst(PurchDetailLine)
        {
            field(Position; Rec.Position)
            {
                ApplicationArea = all;
            }
        }
    }
}

pageextension 80022 gimPurchQuoteSubform extends "Purchase Quote Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }
    }
}

pageextension 80023 gimPurchCrMemoSubform extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }

        // addafter("Job No.")
        // {
        //     field(Position; Rec.Position)
        //     {
        //         ApplicationArea = all;
        //     }
        // }
    }
}
