pageextension 80015 gimWarehouseActivityLines extends "Warehouse Activity Lines"
{
    layout
    {

    }
    actions
    {
        addfirst(Reporting)
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
                    i: integer;
                begin

                    if rec.findset() then
                        repeat
                            SalesHeader.init;
                            SalesHeader."No." := rec."Source No.";
                            if Not SalesHeader.insert then SalesHeader.modify;
                        until rec.Next() = 0;

                    For i := 1 to 3 DO BEGIN
                        if SalesHeader.FINDSET() then
                            repeat

                                WarehouseActivityLine.Setrange("Whse. Document No.", Rec."Whse. Document No.");
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

                                    Report.Run(Report::"CCO Sales Packing List (New)", false, false, WarehouseActivityHeader);


                                end;
                            until SalesHeader.next = 0;
                    end;
                end;
            }
        }
    }
}