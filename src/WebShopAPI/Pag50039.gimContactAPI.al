/// <summary>
/// Page gimContact (ID 50039).
/// </summary>
page 80008 gim2ContactAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimContact';
    DelayedInsert = true;
    EntityName = 'gimContact2';
    EntitySetName = 'gimContacts2';
    PageType = API;
    SourceTable = Contact;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(companyNo; Rec."Company No.")
                {
                    Caption = 'Company No.';
                }
                field(companyName; Rec."Company Name")
                {
                    Caption = 'Company Name';
                }
                field(salespersonCode; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                }
                field(salutationCode; Rec."Salutation Code")
                {
                    Caption = 'Salutation Code';
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(SystemModifiedAt; rec.SystemModifiedAt)
                {
                    caption = 'SystemModifiedAt';
                }
            }
        }
    }
}
