pageextension 80007 "CCO Production BOM Ext" extends "Production BOM"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2") { ApplicationArea = All; }
        }
    }
    actions
    {
        addlast(Reporting)
        {
            action(CCOPrintProductionBOM)
            {
                ApplicationArea = All;
                Caption = 'Production BOM';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    ProductionBOMHeader: Record "Production BOM Header";
                begin
                    ProductionBOMHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"CCO Production BOM", true, false, ProductionBOMHeader);
                end;

            }
        }
    }
}
