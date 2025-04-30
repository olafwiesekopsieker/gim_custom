/// <summary>
/// Page gimServiceInvoiceAPI (ID 50003).
/// </summary>
page 80004 gim2ServiceInvoiceAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimServiceInvoiceHeaderAPI';
    DelayedInsert = true;
    EntityName = 'gimServiceInvoiceHeader2';
    EntitySetName = 'gimServiceInvoiceHeaders2';
    PageType = API;
    SourceTable = "Service Invoice Header";

    layout
    {
        area(Content)
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
                // field(externalDocumentNo; Rec."External Document No.")
                // {
                //     Caption = 'External Document No.';
                // }
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }

            }
        }
    }
}
