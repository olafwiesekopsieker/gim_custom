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
    EntityName = 'gimSalesHeader2';
    EntitySetName = 'gimSalesHeaders2';
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
                field("SellToCustomerName"; Rec."Sell-to Customer Name")
                {
                    caption = 'Sell-to Customer Name';
                }
                field("SellToCustomerName2"; Rec."Sell-to Customer Name 2")
                {
                    Caption = 'Sell-to Customer Name 2';
                }
                field("SellToAddress2"; Rec."Sell-to Address 2")
                {
                    caption = 'Sell-to Adress 2';
                }
                field("SellToCity"; Rec."Sell-to City")
                {
                    caption = 'Sell-to City';
                }
                field("SellToPostCode"; Rec."Sell-to Post Code")
                {
                    caption = 'Sell-to Post Code';
                }
                field("SellToCountryRegionCode"; Rec."Sell-to Country/Region Code")
                {
                    caption = 'Sell-to Country';
                }

            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        rec.calcfields(amount);
    end;


}
