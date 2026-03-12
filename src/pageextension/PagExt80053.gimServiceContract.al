pageextension 80064 "gimServiceContractQuote2" extends "Service Contract Quote"
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

pageextension 80065 "gimServiceContract2" extends "Service Contract"
{
    layout
    {
        addlast(Service)
        {
            field("LEAD Nummer"; Rec."LEAD Nummer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the LEAD Number.';
            }
        }
    }
}

pageextension 80066 "gimServiceContractList2" extends "Service Contracts"
{
    layout
    {
        addafter(Name)
        {
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the second address line.';
            }
            field("Post Code"; Rec."Post Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the postal code.';
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the city.';
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies your reference.';
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the e-mail address.';
            }
            field("Ship-to E-Mail"; Rec."Ship-to E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the ship-to e-mail address.';
            }
        }
    }
}
