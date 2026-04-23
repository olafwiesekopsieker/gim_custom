pageextension 80055 "gimPostedSalesShipment" extends "Posted Sales Shipment"
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

pageextension 80056 "gimPostedSalesInvoice" extends "Posted Sales Invoice"
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

pageextension 80057 "gimPostedSalesCrMemo" extends "Posted Sales Credit Memo"
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

pageextension 80058 "gimPostedReturnReceipt2" extends "Posted Return Receipt"
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
