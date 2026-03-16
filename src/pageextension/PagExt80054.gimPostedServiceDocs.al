pageextension 80067 "gimPostedServiceShipment" extends "Posted Service Shipment"
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

pageextension 80068 "gimPostedServiceInvoice2" extends "Posted Service Invoice"
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

pageextension 80069 "gimPostedServiceCrMemo" extends "Posted Service Credit Memo"
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
