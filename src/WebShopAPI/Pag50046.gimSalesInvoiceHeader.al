page 80013 gim2SalesInvoiceHeader
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimSalesInvoiceHeader';
    DelayedInsert = true;
    EntityName = 'gimSalesInvoice2';
    EntitySetName = 'gimSalesInvoices2';
    PageType = API;
    SourceTable = "Sales Invoice Header";

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
