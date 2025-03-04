pageextension 80006 "CCO Inventory Pick" extends "Inventory Pick"
{
    layout
    {
        addlast(General)
        {
            field("Sales Header Additional Status"; Rec."Sales Header Additional Status")
            {
                ApplicationArea = All;
            }
        }
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
                    WarehouseActivityHeader.SetRange(Type, Rec.Type);
                    WarehouseActivityHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"CCO Sales Packing List (New)", true, false, WarehouseActivityHeader);
                end;
            }
        }

    }
}