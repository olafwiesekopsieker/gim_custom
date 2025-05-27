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
                begin
                    WarehouseActivityHeader.SetRange(Type, WarehouseActivityHeader.Type::Pick);
                    WarehouseActivityHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"CCO Sales Packing List (New)", true, false, WarehouseActivityHeader);
                end;
            }
        }
    }
}
