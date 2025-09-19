pageextension 80001 gimSalesOrderSubform extends "Sales Order Subform"
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

pageextension 80002 gimSalesInvoiceSubform extends "Sales Invoice Subform"
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

pageextension 80018 gimSalesQuoteSubform extends "Sales Quote Subform"
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

pageextension 80019 gimSalesCrMemoSubform extends "Sales Cr. Memo Subform"
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
