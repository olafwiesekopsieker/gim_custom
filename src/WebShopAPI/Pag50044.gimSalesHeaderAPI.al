/// <summary>
/// Page gimSalesHeaderAPI (ID 50044).
/// </summary>
page 80011 gim2SalesHeaderAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimSalesHeaderAPI';
    DelayedInsert = true;
    EntityName = 'gimSalesHeader';
    EntitySetName = 'gimSalesHeaders';
    PageType = API;
    SourceTable = "Sales Header";


    layout
    {
        area(content)
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

    trigger OnAfterGetCurrRecord()
    begin
        rec.calcfields(amount);
    end;


}
