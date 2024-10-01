page 80015 gim2ContactMailGroupAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimContactMailGroup';
    DelayedInsert = true;
    EntityName = 'gimContactMailGroup';
    EntitySetName = 'gimContactMailGroups';
    PageType = API;
    SourceTable = "Contact Mailing Group";
    SourceTableView = Where("Mailing Group Code" = Filter('PARTNERPOR'));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(companyNo; Rec."Company No.")
                {
                    Caption = 'Company No.';
                }
                field(contactCompanyName; Rec."Contact Company Name")
                {
                    Caption = 'Contact Company Name';
                }
                field(contactName; Rec."Contact Name")
                {
                    Caption = 'Contact Name';
                }
                field(contactNo; Rec."Contact No.")
                {
                    Caption = 'Contact No.';
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'E-Mail';
                }
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(mailingGroupCode; Rec."Mailing Group Code")
                {
                    Caption = 'Mailing Group Code';
                }
                field(mailingGroupDescription; Rec."Mailing Group Description")
                {
                    Caption = 'Mailing Group Description';
                }
                field(salespersonCode; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
            }
        }
    }
}
