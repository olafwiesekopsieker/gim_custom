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

            // action(AllItemsOnNoPlanningForEMAD)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Alle Artikel auf nicht berücksichtigen beim EMAD';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = ResetStatus;

            //     trigger OnAction()
            //     var
            //         item: record Item;

            //     begin
            //         if userid = 'HEW\OLAF.WIESEKOPSIEKER' then
            //             item.modifyall("NETVAPS Excl. From EMAD", true);
            //     end;
            // }

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


            action(DeleteServiceContractServiceLine)
            {
                ApplicationArea = All;
                Caption = 'Servicezeilen im Servicevertrag löschen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    SL: record "Service Contract Service Line";

                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin

                        sl.deleteall(false);

                        message('job erledigt');

                    end;

                end;
            }

            action(CoSFillOrderno)
            {
                ApplicationArea = All;
                Caption = 'Gelangenbestätigung Daten reparieren';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    COSFill: Codeunit gimCoSFillMgt;
                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin


                        cosfill.RebuildCoSForPostingDateRange(20240901D, 20251231D);
                        CosFill.ResetSuspiciousInvoiceNos();
                        CosFill.BackfillOrderNo();
                        CosFill.BackfillInvoiceNo();

                        message('job erledigt');

                    end;

                end;
            }

            action(DeleServCrMemoLines)
            {
                ApplicationArea = All;
                Caption = 'Lösche verwaiste ServCredMemoLines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    gimBDMan: Codeunit gimDBManagement;
                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin


                        gimBDMan.DeleteOrphanedServicceCrMemoLines();

                        message('job erledigt');

                    end;

                end;
            }

            // action(CoSFillInvoiceNo)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Gelangenbestätigung Rechnungsnr. füllen';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = ResetStatus;

            //     trigger OnAction()
            //     var
            //         COSFill: Codeunit gimCoSFillMgt;

            //     begin
            //         if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin

            //             //CosFill.FillOrderNo();
            //             cosFill.BackfillInvoiceNoFromShipment();

            //             message('job erledigt');

            //         end;

            //     end;
            // }

            action(DeactivateAllJobQueueEntries)
            {
                ApplicationArea = All;
                Caption = 'Alle Aufgabenwarteschlangenposten deaktvieren';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    dbMan: codeunit gimDBManagement;

                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin

                        dbman.RunDisableAllJobQueues();

                        message('job erledigt');

                    end;

                end;
            }

            // action(RunEtagisImport)
            // {
            //     ApplicationArea = All;
            //     Caption = 'etagis Import starten';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = ResetStatus;

            //     trigger OnAction()
            //     var
            //         etagis: codeunit BMSEtagisImportDetailLineV2;
            //         etagisImportDetails: record BMSEtagisImportDetails;

            //     begin
            //         if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin

            //             etagisImportDetails.Reset();
            //             etagisImportDetails.SetCurrentKey("Entry No.");
            //             etagisImportDetails.SetRange(Status, etagisImportDetails.Status::New);
            //             if etagisImportDetails.FindFirst() then begin


            //                 etagisImportDetails.Status := etagisImportDetails.Status::"In Progress";
            //                 etagisImportDetails.Modify();
            //             END;

            //             etagis.run;

            //             message('job erledigt');

            //         end;

            //     end;
            // }





            // // action(CopyNETVAPSField)
            // // {
            // //     ApplicationArea = All;
            // //     Caption = 'Copy NETVAPS-Field';
            // //     Promoted = true;
            // //     PromotedCategory = Process;
            // //     PromotedIsBig = true;
            // //     Image = Copy;

            // //     trigger OnAction()
            // //     var
            // //         Item: record Item;

            // //     begin
            // //         if userid = 'HEW\OLAF.WIESEKOPSIEKER' then begin
            // //             if item.findset() then
            // //                 repeat
            // //                     item.gimNichtInEtagisPlanen := item."NETVAPS Excl. From EMAD";
            // //                     item.modify(false);
            // //                 until item.next = 0;

            // //         end;

            // //     end;
            // // }


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
