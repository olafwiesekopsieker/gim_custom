/// <summary>
/// Page gimItemAttrValueTransl (ID 80017).
/// </summary>
page 80017 gimItemAttrValueTransl
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimItemAttrValueTransl';
    DelayedInsert = true;
    EntityName = 'gimItemAttrValueTrans';
    EntitySetName = 'gimItemAttrValueTranss';
    PageType = API;
    SourceTable = "Item Attr. Value Translation";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(attributeID; Rec."Attribute ID")
                {
                    Caption = 'Attribute ID';
                }
                field(id; Rec.ID)
                {
                    Caption = 'ID';
                }
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
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
