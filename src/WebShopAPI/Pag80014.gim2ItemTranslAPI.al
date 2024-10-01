page 80014 gim2ItemTranslAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimItemTranslAPI';
    DelayedInsert = true;
    EntityName = 'gim2ItemTransl';
    EntitySetName = 'gim2ItemTransln';
    PageType = API;
    SourceTable = "Item Translation";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ccsDMDescription3; Rec."CCS DM Description 3")
                {
                    Caption = 'Description 3';
                }
                field(ccsDMDescription4; Rec."CCS DM Description 4")
                {
                    Caption = 'Description 4';
                }
                field(ccsDMDescription5; Rec."CCS DM Description 5")
                {
                    Caption = 'Description 5';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
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
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
            }
        }
    }
}
