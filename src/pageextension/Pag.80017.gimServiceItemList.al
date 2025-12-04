pageextension 80017 gimServiceItemList2 extends "Service Item List"
{
    layout
    {
        addafter("Ship-to Code")
        {
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                caption = 'Lief. An Name';
                ApplicationArea = All;
            }
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                caption = 'Lief. An Name 2';
                ApplicationArea = All;
            }
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
                caption = 'Lief. An Adresse 2';
                ApplicationArea = All;
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                caption = 'Lief. An PLZ';
                ApplicationArea = All;
            }
            field("Ship-to City"; Rec."Ship-to City")
            {
                caption = 'Lief. An Ort';
                ApplicationArea = All;
            }
            field("Ship-to Contact"; Rec."Ship-to Contact")
            {
                caption = 'Lief. An Kontakt';
                ApplicationArea = All;
            }
            field("Ship-to Phone No."; Rec."Ship-to Phone No.")
            {
                caption = 'Lief. An Telefonnr.';
                ApplicationArea = All;
            }
            field("Ship-to E-Mail"; Rec."Ship-to E-Mail")
            {
                caption = 'Lief. An E-Mail';
                ApplicationArea = All;
            }
            field("Location of Service Item"; Rec."Location of Service Item")
            {
                caption = 'Standort';
                ApplicationArea = All;
            }
        }
    }
}
