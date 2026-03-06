pageextension 80070 "gimPurchQuote" extends "Purchase Quote"
{
    layout
    {
        addlast(General)
        {
            // field("LEAD Nummer"; Rec."LEAD Nummer")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the LEAD Number.';
            // }
        }
    }
}



pageextension 80071 "gimPurchInvoice" extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            // field("LEAD Nummer"; Rec."LEAD Nummer")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the LEAD Number.';
            // }
            field("PostingDescription"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
            field("kmirmDocumentID"; Rec."kmirm Document id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Document id.';
            }
        }
    }
}

pageextension 80072 "gimPurchCrMemo2" extends "Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            // field("LEAD Nummer"; Rec."LEAD Nummer")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the LEAD Number.';
            // }
            field("PostingDescription"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
            field("kmirmDocumentID"; Rec."kmirm Document id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Document id.';
            }
        }
    }
}

pageextension 80073 "gimPurchReturnOrder" extends "Purchase Return Order"
{
    layout
    {
        addlast(General)
        {
            // field("LEAD Nummer"; Rec."LEAD Nummer")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the LEAD Number.';
            // }
        }
    }
}
