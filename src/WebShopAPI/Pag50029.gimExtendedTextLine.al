page 80006 gim2ExtendedTextLine
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimExtendedTextLine';
    DelayedInsert = true;
    EntityName = 'gimItemTextLine';
    EntitySetName = 'gimItemTextLines';
    PageType = API;
    SourceTable = "Extended Text Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(tableName; Rec."Table Name")
                {
                    Caption = 'Table Name';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(TextNo; rec."Text No.")
                {
                    Caption = 'Text No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field("text"; Rec."Text")
                {
                    Caption = 'Text';
                }
            }
        }
    }
}
