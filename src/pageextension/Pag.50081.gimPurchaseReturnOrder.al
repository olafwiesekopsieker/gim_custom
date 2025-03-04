/// <summary>
/// PageExtension gimPurchaseReturnOrder (ID 50081) extends Record Purchase Return Order.
/// </summary>
pageextension 80011 gimPurchaseReturnOrder extends "Purchase Return Order"
{
    layout
    {
        addafter("Buy-from Contact")
        {

            field(RegistrierNr; Rec.RegistrierNr)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(Warehouse)
        {
            action(PrintReturnSlip)
            {
                Caption = 'Return Slip';
                Image = Print;
                ApplicationArea = all;
                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                begin
                    PurchHeader := Rec;
                    PurchHeader.SetRecFilter();
                    Report.Run(Report::"CCO Purchase Return Shipment", true, false, PurchHeader);
                end;
            }
        }
        //     addlast("&Return Order")
        //     {

        //         action(D3Document)
        //         {
        //             Caption = 'D3-Dokument';

        //             trigger onAction()
        //             var
        //                 d3Journal: record "d3 Journal";
        //             begin
        //                 if d3_doc_id <> '' then
        //                     d3journal.openDocument(d3_doc_id);
        //             end;
        //         }
        //     }
    }
}
