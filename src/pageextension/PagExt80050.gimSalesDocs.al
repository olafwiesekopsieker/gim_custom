pageextension 80050 "gimSalesQuote" extends "Sales Quote"
{
    layout
    {
        addlast(General)
        {
            field("LEAD Nummer"; Rec."LEAD Nummer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the LEAD Number.';
            }
        }
    }
}



pageextension 80052 "gimSalesInvoice" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("LEAD Nummer"; Rec."LEAD Nummer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the LEAD Number.';
            }
            field("PostingDescription";Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
        }
    }
}

pageextension 80053 "gimSalesCrMemo" extends "Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("LEAD Nummer"; Rec."LEAD Nummer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the LEAD Number.';
            }
             field("PostingDescription";Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
        }
    }
}

pageextension 80054 "gimSalesReturnOrder" extends "Sales Return Order"
{
    layout
    {
        addlast(General)
        {
            field("LEAD Nummer"; Rec."LEAD Nummer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the LEAD Number.';
            }
        }
    }
}
