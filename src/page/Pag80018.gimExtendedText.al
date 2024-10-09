/// <summary>
/// Page gimExtendedText (ID 80018).
/// </summary>
page 80018 gimExtendedText
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimExtendedText';
    DelayedInsert = true;
    EntityName = 'gimExtendedText';
    EntitySetName = 'gimExtendedTexts';
    PageType = API;
    SourceTable = "Extended Text Line";
    SourceTableView = where("Table Name" = const("item"));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
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
                field(tableName; Rec."Table Name")
                {
                    Caption = 'Table Name';
                }
                field("text"; Rec."Text")
                {
                    Caption = 'Text';
                }
                field(textNo; Rec."Text No.")
                {
                    Caption = 'Text No.';
                }
            }
        }
    }
}
