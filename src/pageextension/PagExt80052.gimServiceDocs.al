pageextension 80060 "gimServiceQuote2" extends "Service Quote"
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

pageextension 80061 "gimServiceOrder2" extends "Service Order"
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

pageextension 80062 "gimServiceInvoice" extends "Service Invoice"
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

pageextension 80063 "gimServiceCrMemo" extends "Service Credit Memo"
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
