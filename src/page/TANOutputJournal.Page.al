page 80019 "gimTANOutputJournal"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // 
    // :PMW14.00:11:1
    //   # Ocject deleted.
    // 
    // :PMW14.02:28:1
    //   # Object created.
    // 
    // :PMW15.00:241:1
    //   # Changes due to UI and programming standards
    // 
    // :PMW15.00:238:1
    //   # Usage of new data access commands
    // 
    // :PMW15.00.01:26:1
    //   # From property ActiveControlOnOpen changed
    //   # Field property NextControl of field "Routing TAN" changed
    // 
    // :PMW16.00:116:1
    //   # Connection between add. information controls deleted due to tansforamtion
    // 
    // #PMW16.00.02.05:T511 16.06.11 DEMSR.IST
    //   Save changes before processing next TAN
    // 
    // #PMW17.00:T101 12.10.12 DEMSR.IST
    //   Update to NAV 2013
    //   ISSERVICETIER condition deleted
    //   Obsolet function OnAfterGetCurrRecord deleted
    // 
    // #PMW17.10.00.03:T100 31.07.14 DEMSR.IST - Rebranding
    // 
    // GIM0009 16.5.2022 MultiFunction im Routing TAN Feld
    //                   Prefix T Standardfunktion
    //                   Prefix S öffnet zugehörige Produktionsstückliste
    // 
    // GIM0016 29.11.2022 Prefix B öffnet gegebenes Journalblatt

    AutoSplitKey = true;
    Caption = 'Düperthal TAN Output Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Item Journal Line";
    ApplicationArea = all;
    UsageCategory = Tasks;


    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Editable = false;
                Enabled = false;
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    ItemJnlMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                    ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
                end;

                trigger OnValidate()
                begin
                    ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }
            field(currTester; currTester)
            {
                Caption = 'Aktueller Tester';
                Editable = false;
                Enabled = false;
            }
            field(RoutingTAN; RoutingTAN)
            {
                Caption = 'Routing TAN';

                trigger OnValidate()
                begin
                    RoutingTANOnAfterValidate();
                end;
            }
            repeater(Control5012400)
            {
                Editable = false;
                Enabled = false;
                ShowCaption = false;
                field("Routing TAN"; Rec."ccs pm Routing TAN")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Order No."; Rec."Order No.")
                {

                    trigger OnValidate()
                    var
                        itemJnlMgt: Codeunit "Mfg. Item Journal Mgt.";
                    begin
                        ItemJnlMgt.GetOutput(Rec, ProdOrderDescription, OperationName);
                    end;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupItemNo();
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Operation No."; Rec."Operation No.")
                {

                    trigger OnValidate()
                    begin
                        MFGItemJnlMgt.GetOutput(Rec, ProdOrderDescription, OperationName);
                    end;
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Work Shift Code"; Rec."Work Shift Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    Visible = false;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    Visible = false;
                }
                field("Concurrent Capacity"; Rec."Concurrent Capacity")
                {
                    Visible = false;
                }
                field("Setup Time"; Rec."Setup Time")
                {
                    Visible = false;
                }
                field("Run Time"; Rec."Run Time")
                {
                }
                field("Cap. Unit of Measure Code"; Rec."Cap. Unit of Measure Code")
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field("Scrap Code"; Rec."Scrap Code")
                {
                    Visible = false;
                }
                field("Output Quantity"; Rec."Output Quantity")
                {
                }
                field("Scrap Quantity"; Rec."Scrap Quantity")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field(Finished; Rec.Finished)
                {
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Visible = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                }
            }
            group(Control5012420)
            {
                ShowCaption = false;
                fixed(Control1900925601)
                {
                    ShowCaption = false;
                    group("Prod. Order Name")
                    {
                        Caption = 'Prod. Order Name';
                        field(ProdOrderDescription; ProdOrderDescription)
                        {
                            Editable = false;
                        }
                    }
                    group(Operation)
                    {
                        Caption = 'Operation';
                        field(OperationName; OperationName)
                        {
                            Caption = 'Operation';
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                        CurrPage.SaveRecord();
                    end;
                }
                action("Item Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines(false);
                    end;
                }
                action("Bin Contents")
                {
                    Caption = 'Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Contents List";
                    RunPageLink = "Location Code" = field("Location Code"),
                                  "Item No." = field("Item No."),
                                  "Variant Code" = field("Variant Code");
                    RunPageView = sorting("Location Code", "Bin Code", "Item No.", "Variant Code");
                }
            }
            group("Pro&d. Order")
            {
                Caption = 'Pro&d. Order';
                Image = "Order";
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Released Production Order";
                    RunPageLink = "No." = field("Order No.");
                    ShortCutKey = 'Shift+F7';
                }
                group("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        Caption = 'Item Ledger E&ntries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type" = const(Production),
                                      "Order No." = field("Order No.");
                        RunPageView = sorting("Order Type", "Order No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        Caption = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Capacity Ledger Entries";
                        RunPageLink = "Order Type" = const(Production),
                                      "Order No." = field("Order No.");
                        RunPageView = sorting("Order Type", "Order No.");
                    }
                    action("Value Entries")
                    {
                        Caption = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Order Type" = const(Production),
                                      "Order No." = field("Order No.");
                        RunPageView = sorting("Order Type", "Order No.");
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Explode &Routing")
                {
                    Caption = 'Explode &Routing';
                    Image = ExplodeRouting;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Output Jnl.-Expl. Route";
                }
                action("Arbeitsblatt wechseln..")
                {
                    Caption = 'Arbeitsblatt wechseln..';

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord();
                        ItemJnlMgt.LookupName(CurrentJnlBatchName, Rec);
                        CurrPage.Update(false);
                        ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintItemJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        TrySetApplyToEntries();
                        Rec.PostingItemJnlFromProduction(false);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        TrySetApplyToEntries();
                        Rec.PostingItemJnlFromProduction(true);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    REPORT.RunModal(REPORT::"Inventory Movement", true, true, ItemJnlLine);
                end;
            }
            action("Produktionsplan Reihenfolgenplanung")
            {
                Caption = 'Produktionsplan Reihenfolgenplanung';
                RunObject = Page SequenceProductionPlanGIM;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MFGItemJnlMgt.GetOutput(Rec, ProdOrderDescription, OperationName);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
    begin
        Commit();
        if not ReserveItemJnlLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveItemJnlLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Rec.Validate("Entry Type", Rec."Entry Type"::Output);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') and (Rec."Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        ItemJnlMgt.TemplateSelection(PAGE::"Output Journal", 5, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);

        //GIM0009
        currTester := '';
    end;

    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        MFGItemJnlMgt: Codeunit "Mfg. Item Journal Mgt.";
        ReportPrint: Codeunit "Test Report-Print";
        ProdOrderDescription: Text[50];
        OperationName: Text[50];
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        RoutingTAN: Code[20];
        currTester: Code[20];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    //
    /// <summary>
    /// TrySetApplyToEntries.
    /// </summary>
    procedure TrySetApplyToEntries()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemJournalLine2: Record "Item Journal Line";
        ReservationEntry: Record "Reservation Entry";
    begin
        ItemJournalLine2.Copy(Rec);
        if ItemJournalLine2.FindSet() then
            repeat
                if FindReservationsReverseOutput(ReservationEntry, ItemJournalLine2) then
                    repeat
                        if FindILEFromReservation(ItemLedgerEntry, ItemJournalLine2, ReservationEntry, Rec."Order No.") then begin
                            ReservationEntry.Validate("Appl.-to Item Entry", ItemLedgerEntry."Entry No.");
                            ReservationEntry.Modify(true);
                        end;
                    until ReservationEntry.Next() = 0;

            until ItemJournalLine2.Next() = 0;
    end;

    local procedure FindReservationsReverseOutput(var ReservationEntry: Record "Reservation Entry"; ItemJnlLine: Record "Item Journal Line"): Boolean
    begin
        if ItemJnlLine.Quantity >= 0 then
            exit(false);

        ReservationEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line");
        ReservationEntry.SetRange("Source ID", ItemJnlLine."Journal Template Name");
        ReservationEntry.SetRange("Source Ref. No.", ItemJnlLine."Line No.");
        ReservationEntry.SetRange("Source Type", DATABASE::"Item Journal Line");
        ReservationEntry.SetRange("Source Subtype", ItemJnlLine."Entry Type");
        ReservationEntry.SetRange("Source Batch Name", ItemJnlLine."Journal Batch Name");

        ReservationEntry.SetFilter("Serial No.", '<>%1', '');
        ReservationEntry.SetRange("Qty. to Handle (Base)", -1);
        ReservationEntry.SetRange("Appl.-to Item Entry", 0);

        exit(ReservationEntry.FindSet());
    end;

    local procedure FindILEFromReservation(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJnlLine: Record "Item Journal Line"; ReservationEntry: Record "Reservation Entry"; ProductionOrderNo: Code[20]): Boolean
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive,
          "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");

        ItemLedgerEntry.SetRange("Item No.", ItemJnlLine."Item No.");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange("Variant Code", ItemJnlLine."Variant Code");
        ItemLedgerEntry.SetRange(Positive, true);
        ItemLedgerEntry.SetRange("Location Code", ItemJnlLine."Location Code");
        ItemLedgerEntry.SetRange("Serial No.", ReservationEntry."Lot No.");
        ItemLedgerEntry.SetRange("Serial No.", ReservationEntry."Serial No.");
        ItemLedgerEntry.SetRange("Document No.", ProductionOrderNo);

        exit(ItemLedgerEntry.FindSet());
    end;

    //
    /// <summary>
    /// HandleRoutingTAN.
    /// </summary>
    procedure HandleRoutingTAN()
    var
        lProdOrderFeedbackService: Codeunit "GIM Prod. Order Feedback Svc";
        myNotification: Notification;
    begin
        // >> #PMW16.00.02.05:T511
        if Rec."Line No." <> 0 then
            if Rec.Modify() then;

        if isProdOrderLineFinished(routingTan) then begin
            myNotification.message('Dieser Fertigungsauftrag scheint schon gebucht zu sein');
            myNotification.send();
            exit;
        end;

        // << #PMW16.00.02.05:T511
        if currTester <> '' then begin
            if lProdOrderFeedbackService.InsertTANOutputJnlLine(Rec, RoutingTAN, currTester, 0, 0) then
                Rec.FindLast();
        end else begin
            myNotification.Message('Bitte legen Sie zuerst einen Prüfer fest');
            myNotification.Send();
        end;
    end;

    local procedure RoutingTANOnAfterValidate()
    var
        strPrefix: Text;
    begin
        //GIM0009 Flexibles Barcodefeld mit verknüpfter Action
        strPrefix := CopyStr(RoutingTAN, 1, 1);
        case UpperCase(strPrefix) of
            'T':
                HandleRoutingTAN();
            'S':
                OpenProdOrderComponents();
            'P':
                setCurrTester();
            'B':
                setJnlBatchname();
            'Q':
                ProcessPulver();
        end;


        //reset Barcode
        CurrPage.Update(false);
        Clear(RoutingTAN);
    end;

    local procedure OpenProdOrderComponents()
    var
        ProdOrderComponent: Record "Prod. Order Component";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderComponents: Page ProdOrderCompGIM;
        posDivider: Integer;
    begin
        //GIM0009
        posDivider := StrPos(RoutingTAN, '$');
        if posDivider > 0 then
            RoutingTAN := CopyStr(RoutingTAN, 1, posDivider - 1);
        ProdOrderRoutingLine.SetRange("ccs pm Routing TAN", CopyStr(RoutingTAN, 2));

        if ProdOrderRoutingLine.FindFirst() then begin
            ProdOrderLine.SetRange(Status, ProdOrderRoutingLine.Status);
            ProdOrderLine.SetRange("Prod. Order No.", ProdOrderRoutingLine."Prod. Order No.");
            ProdOrderLine.SetRange("Line No.", ProdOrderRoutingLine."Routing Reference No.");
            if ProdOrderLine.FindFirst() then begin
                ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
                ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                if ProdOrderComponent.FindSet() then begin
                    ProdOrderComponents.SetTableView(ProdOrderComponent);
                    ProdOrderComponents.Editable(false);
                    ProdOrderComponents.RunModal();
                end;
            end;
        end;
    end;

    local procedure setCurrTester()
    begin
        //GIM0009
        currTester := CopyStr(RoutingTAN, 2);
    end;

    //
    /// <summary>
    /// setCurrJnlBatchName.
    /// </summary>
    /// <param name="strName">Code[10].</param>
    procedure setCurrJnlBatchName(strName: Code[10])
    begin
        CurrentJnlBatchName := strName;
    end;

    local procedure setJnlBatchname()
    begin
        CurrPage.SaveRecord();
        //ItemJnlMgt.LookupName(CurrentJnlBatchName,Rec);
        setCurrJnlBatchName := CopyStr(RoutingTAN, 2);
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
        ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
    end;

    local procedure ProcessPulver()
    var
        lProdOrderFeedbackService: Codeunit "GIM Prod. Order Feedback Svc";
        dialogPulvern: Page DialogPulvern;
        OutputQty: Decimal;
        ScrapQty: Decimal;
        LableQty: Decimal;
        IsLastOperation: Boolean;
    begin
        //Ermittle FA-Zeile

        //Fertiggestellte Menge (Output Qty) abfragen
        //Etikettenanzahl abfragen (max 50)
        IsLastOperation := true; //lProdOrderFeedbackService.IsLastOperationWithTAN(COPYSTR(RoutingTAN,2));
        dialogPulvern.SetVisiblity(IsLastOperation);
        if dialogPulvern.RunModal() = ACTION::OK then begin
            OutputQty := dialogPulvern.GetOutputQty();
            ScrapQty := dialogPulvern.GetScrapQuantity();
            LableQty := dialogPulvern.GetLableQty();
        end;

        //MESSAGE('Fertigestellte Menge: %1 Anzahl Etiketten: %2',OutputQty,LableQty);
        //Buchungszeile erstellen
        if lProdOrderFeedbackService.InsertTANOutputJnlLine(Rec, CopyStr(RoutingTAN, 2), currTester, OutputQty, ScrapQty) then
            Rec.FindLast();
        if lProdOrderFeedbackService.InsertTANOutputJnlLine(Rec, CopyStr(IncStr(RoutingTAN), 2), currTester, OutputQty, ScrapQty) then
            Rec.FindLast();


        //Etiketten drucken
        if LableQty > 0 then
            PrintPulverLable();
    end;

    procedure PrintPulverLable()
    var
        ProdLine: Record "Prod. Order Line";
        ProdRouting: Record "Prod. Order Routing Line";
        ProdLabel: Report "CCO Label Production";
    begin
        //GIM Simes 13.02.2023: Hier wurde die ProdLine direkt nach der RoutingTAN gefiltert, das musste erst über die ProdRoutings gehen, sonst war der Bericht immer leer
        ProdRouting.SetRange("ccs pm Routing TAN", CopyStr(RoutingTAN, 2));
        if ProdRouting.FindFirst() then begin
            ProdLine.SetRange(Status, 3);
            ProdLine.SetRange("Prod. Order No.", ProdRouting."Prod. Order No.");
            ProdLabel.SetTableView(ProdLine);
            ProdLabel.UseRequestPage(false);
            ProdLabel.RunModal();
        end;
    end;

    /// <summary>
    /// IsProdOrderLineFinished.
    /// </summary>
    /// <returns>Return variable ret of type boolean.</returns>
    local procedure IsProdOrderLineFinished(locRoutingTan: code[50]) ret: boolean
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderLine: record "Prod. Order line";
        posDivider: Integer;
    begin
        posDivider := StrPos(locRoutingTAN, '$');
        if posDivider > 0 then
            locRoutingTAN := CopyStr(locRoutingTAN, 1, posDivider - 1);

        ret := false;
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetCurrentKey("ccs pm Routing TAN");
        ProdOrderRoutingLine.SetRange("ccs pm Routing TAN", locRoutingTAN);
        ProdOrderRoutingLine.SetFilter(Status, '%1|%2', ProdOrderRoutingLine.Status::Released, ProdOrderRoutingLine.Status::Finished);
        if ProdOrderRoutingLine.FindFirst() then begin
            IF not ProdOrderLine.Get(ProdOrderRoutingLine.Status, ProdOrderRoutingLine."Prod. Order No.",
                                       ProdOrderRoutingLine."Routing Reference No.") then
                ProdOrderline.init
            ELSE begin
                if ProdOrderLine.status = ProdOrderLine.status::Finished then ret := true;
                if ProdOrderLine.status = ProdOrderline.status::released then begin
                    IF prodorderline.Quantity = ProdOrderline."Finished Quantity" then ret := true;
                end;
            end;



        End;

    end;
}

