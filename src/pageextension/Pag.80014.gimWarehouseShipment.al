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
                    WarehouseActivityHeader: Record "Warehouse Activity Header" temporary;
                    WarehouseActivityLine: Record "Warehouse Activity Line";
                begin


                    WarehouseActivityLine.Setrange("Whse. Document No.", Rec."No.");
                    if WarehouseActivityLine.FINDfirst() then begin
                        WarehouseActivityHeader.init;
                        WarehouseActivityHeader.Type := WarehouseActivityHeader.type::Pick;
                        WarehouseActivityHeader."No." := WarehouseActivityLine."No.";
                        WarehouseActivityHeader."Source No." := WarehouseActivityLine."Source No.";
                        WareHouseActivityHeader.insert;


                        WarehouseActivityHeader.SetRange("No.", WarehouseActivityLine."No.");
                        Report.Run(Report::"CCO Sales Packing List (New)", true, false, WarehouseActivityHeader);
                    end;
                end;
            }
        }
    }
}
