pageextension 80014 gimWarehouseShipment extends "Warehouse Shipment"
{
    layout
    {

    }
    actions
    {
        addlast(reporting)
        {
            action("CCO Print Picking List DUE")
            {
                Caption = 'Picking List DUE';
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    WarehouseActivityHeader: Record "Warehouse Activity Header";
                    WarehouseActivityLine: Record "Warehouse Activity Line";
                    SalesHeader: record "Sales Header" temporary;
                begin
                    WarehouseActivityLine.Setrange("Whse. Document No.", Rec."No.");
                    if WarehouseActivityLine.findset() then
                        repeat
                            SalesHeader.init;
                            SalesHeader."No." := WarehouseActivityLine."Source No.";
                            if Not SalesHeader.insert then SalesHeader.modify;
                        until Rec.Next() = 0;

                    if SalesHeader.FINDSET() then
                        repeat

                            WarehouseActivityLine.Setrange("Whse. Document No.", Rec."No.");
                            warehouseActivityLine.setrange("Source No.", salesHeader."No.");
                            if WarehouseActivityLine.FINDfirst() then begin
                                WarehouseActivityHeader.init;
                                WarehouseActivityHeader.Type := WarehouseActivityHeader.type::Pick;
                                WarehouseActivityHeader."No." := WarehouseActivityLine."No.";
                                WarehouseActivityHeader."Source No." := WarehouseActivityLine."Source No.";
                                WareHouseActivityHeader."Source Type" := Database::"Sales Line";
                                WarehouseActivityHeader."Source Subtype" := salesheader."Document Type"::order.asInteger;
                                WareHouseActivityHeader.Modify;

                                Commit();

                                WarehouseActivityHeader.SETRANGE("No.", WarehouseActivityHeader."No.");

                                Report.Run(Report::"CCO Sales Packing List (New)", true, false, WarehouseActivityHeader);


                            end;
                        until SalesHeader.next = 0;
                end;

            }
        }
    }
}
