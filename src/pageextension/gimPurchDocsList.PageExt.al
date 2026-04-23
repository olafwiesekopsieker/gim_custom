Pageextension 80031 "gimPurchInvoices" extends "Purchase Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("kmirmDocumentID"; Rec."kmirm Document id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Document id.';
            }
            field("PostingDescription"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
        }
    }
}
Pageextension 80032 "gimPurchCreditMemos" extends "Purchase Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("kmirmDocumentID"; Rec."kmirm Document id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Document id.';
            }
            field("PostingDescription"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
        }
    }
}

pageextension 80033 "gimPostedPurchInvoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("kmirmDocumentID"; Rec."kmirm Document id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Document id.';
            }
            field("PostingDescription"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
        }
    }
}

pageextension 80034 "gimPostedPurchCreditMemos" extends "Posted Purchase Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("kmirmDocumentID"; Rec."kmirm Document id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Document id.';
            }
            field("PostingDescription"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Posting Description.';
            }
        }
    }
}