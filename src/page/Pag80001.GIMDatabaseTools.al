/// <summary>
/// Page "GIM_DatabaseTools" (ID 82001).
/// </summary>
page 80001 GIM_DatabaseTools
{
    ApplicationArea = All;
    Caption = 'GIM Database Tools';
    PageType = Card;
    SourceTable = "Customer";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ResetApplicationAreas)
            {
                ApplicationArea = All;
                Caption = 'Application Areas zurücksetzen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    ApplicationAreaSetup: record "Application Area Setup";
                    ExperienceTierSetup: record "Experience Tier Setup";
                begin
                    ApplicationAreaSetup.DELETEALL;
                    ExperienceTierSetup.DELETEALL;
                end;
            }

            action(AllItemsOnNoPlanningForEMAD)
            {
                ApplicationArea = All;
                Caption = 'Alle Artikel auf nicht berücksichtigen beim EMAD';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    item: record Item;

                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then
                        item.modifyall("NETVAPS Excl. From EMAD", true);
                end;
            }

            action(DeleteUmlagerung)
            {
                ApplicationArea = All;
                Caption = 'Umlagerung löschen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    TransferHeader: record "Transfer Header";
                    TransferLine: record "Transfer Line";

                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin
                        TransferLine.Setrange("Document No.", 'UL2410108');
                        TransferLine.DELETEALL(false);

                        TransferHeader.SETRANGE("No.", 'UL2410108');
                        TransferHeader.DELETEAll(False);

                        message('job erledigt');

                    end;

                end;
            }


            action(CopyNETVAPSField)
            {
                ApplicationArea = All;
                Caption = 'Copy NETVAPS-Field';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Copy;

                trigger OnAction()
                var
                    Item: record Item;

                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin
                        if item.findset() then
                            repeat
                                item.gimNichtInEtagisPlanen := item."NETVAPS Excl. From EMAD";
                                item.modify(false);
                            until item.next = 0;

                    end;

                end;
            }


            action(syncColorsToItem)
            {
                ApplicationArea = All;
                Caption = 'sync Farbe zu Artikel';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Copy;

                trigger onAction()
                var
                    ProdDim: record "CCS PX Default Mfg. Dimension";
                    item: record item;
                begin
                    ProdDim.setrange("Table ID", 27);
                    ProdDim.setrange("Mfg. Dimension Code", 'FARBE');
                    if PRODDim.FINDSET() then
                        repeat
                            if item.get(prodDim."No.") then begin
                                item.gimRALCode := ProdDim."Mfg. Dimension Value Code";
                                item.modify;
                            end;
                        until ProdDim.Next() = 0;
                end;
            }
        }
    }


}
