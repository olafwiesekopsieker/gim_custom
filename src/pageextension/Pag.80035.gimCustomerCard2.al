pageextension 80035 gimCustomerCard2 extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Unsere Kundennr.';
            }
        }
    }
}
