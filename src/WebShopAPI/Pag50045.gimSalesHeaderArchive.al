page 80012 gim2SalesHeaderArchive
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimSalesHeaderArchive';
    DelayedInsert = true;
    EntityName = 'gimSalesHeaderAchive3';
    EntitySetName = 'gimSalesHeaderArchives3';
    PageType = API;
    SourceTable = "Sales Header Archive";

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
                field(versionNo; Rec."Version No.")
                {
                    Caption = 'Version No.';
                }
                field(billToName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-to Name';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(salesQuoteNo; Rec."Sales Quote No.")
                {
                    Caption = 'Sales Quote No.';
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
        rec.calcfields(Amount);
    end;
}
