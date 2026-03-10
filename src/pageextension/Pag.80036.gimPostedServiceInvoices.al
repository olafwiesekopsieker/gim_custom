pageextension 80036 gimPostedServiceInvoices2 extends "Posted Service Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("LEAD Nummer"; Rec."LEAD Nummer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the LEAD Number.';
            }
            field("gimQty Service Items"; Rec."gimQty Service Items")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the quantity of service items.';
            }
        }
    }
}
