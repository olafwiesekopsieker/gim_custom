pageextension 80038 "gimPostedPurchInvoice" extends "Posted Purchase Invoice"
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
            field("kmirm Barcode"; Rec."kmirm Barcode")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Barcode.';
            }
        }
    }
}

pageextension 80039 "gimPostedPurchCrMemo2" extends "Posted Purchase Credit Memo"
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
            field("kmirm Barcode"; Rec."kmirm Barcode")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the kmirm Barcode.';
            }
        }
    }
}
