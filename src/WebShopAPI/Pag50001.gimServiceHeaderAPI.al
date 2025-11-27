/// <summary>
/// Page gimServiceHeaderAPI (ID 50001).
/// </summary>
page 80002 gim2ServiceHeaderAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimServiceHeaderAPI';
    DelayedInsert = true;
    EntityName = 'gimServiceHeader2';
    EntitySetName = 'gimServiceHeaders2';
    PageType = API;
    SourceTable = "Service Header";

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
                // field(externalDocumentNo; Rec."External Document No.")
                // {
                //     Caption = 'External Document No.';
                // }
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
