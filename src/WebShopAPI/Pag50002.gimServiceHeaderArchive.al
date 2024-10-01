/// <summary>
/// Page gimServiceHeaderArchive (ID 50002).
/// </summary>
page 80003 gim2ServiceHeaderArchive
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimArchServiceHeaderAPI';
    DelayedInsert = true;
    EntityName = 'gimArchServiceHeader';
    EntitySetName = 'gimArchServiceHeaders';
    PageType = API;
    SourceTable = "MUL SNAD Arch Serv. Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(billToName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-to Name';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(quoteNo; Rec."Quote No.")
                {
                    Caption = 'Quote No.';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
            }
        }
    }
}
