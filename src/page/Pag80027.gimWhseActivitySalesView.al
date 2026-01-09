page 80027 "gim Whse Activity Sales View"
{
    PageType = List;
    SourceTable = "Warehouse Activity Line";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Warehouse Activity Lines – Sales View';

    // Optional: typischerweise willst du nur Pick/Put-away etc. sehen.
    // Passe das an euren Use-Case an.
    SourceTableView = sorting("No.", "Line No.")
                      where("Activity Type" = const(Pick));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // ===== Gewünschte “Sales-Infos” =====
                field(SalesOrderNo; SalesOrderNo)
                {
                    Caption = 'Verkaufsauftrag';
                    ToolTip = 'Quelle (Herkunftsnummer) aus dem Verkaufsauftrag.';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        OpenSalesOrder();
                    end;
                }

                field(CustomerNo; CustomerNo)
                {
                    Caption = 'Debitor-Nr.';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        OpenCustomer();
                    end;
                }

                field(CustomerName; CustomerName)
                {
                    Caption = 'Debitor Name';
                    Editable = false;
                }

                field(ShipmentDate; ShipmentDate)
                {
                    Caption = 'Warenausgangsdatum';
                    Editable = false;
                }

                field(ShippingAgentCode; ShippingAgentCode)
                {
                    Caption = 'Zustellercode';
                    Editable = false;
                }

                // ===== Artikeldaten / Whse-Daten =====
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Artikelnummer';
                }

                field(ItemDescription; ItemDescription)
                {
                    Caption = '(Artikel) Beschreibung';
                    Editable = false;
                }

                field(Quantity; Quantity)
                {
                    Caption = 'Menge';
                    Editable = false;
                }

                field("Bin Code"; Rec."Bin Code")
                {
                    Caption = 'Lagerplatzcode';
                }

                field(CalendarWeek; CalendarWeek)
                {
                    Caption = 'KW';
                    Editable = false;
                }

                field(CustomerComment; CustomerComment)
                {
                    Caption = 'Kommentar - Kunde';
                    Editable = false;
                }

                field(SellerCode1; SellerCode1)
                {
                    Caption = 'Verkäufercode 1';
                    Editable = false;
                }

                field(SellerCode2; SellerCode2)
                {
                    Caption = 'Verkäufercode 2';
                    Editable = false;
                }

                field(ExtraStatus; ExtraStatus)
                {
                    Caption = 'Zusatzstatus';
                    Editable = false;
                }

                field(NetAmount; NetAmount)
                {
                    Caption = 'Nettobetrag';
                    Editable = false;
                }

                // ===== Optional: nützliche Whse-Felder =====
                field("No."; Rec."No.")
                {
                    Caption = 'Whse Activity No.';
                }

                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenSalesOrderAction)
            {
                Caption = 'Verkaufsauftrag öffnen';
                ApplicationArea = All;
                Image = Document;

                trigger OnAction()
                begin
                    OpenSalesOrder();
                end;
            }

            action(OpenCustomerAction)
            {
                Caption = 'Debitor öffnen';
                ApplicationArea = All;
                Image = Customer;

                trigger OnAction()
                begin
                    OpenCustomer();
                end;
            }

            action(OpenItemAction)
            {
                Caption = 'Artikel öffnen';
                ApplicationArea = All;
                Image = Item;

                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    if Rec."Item No." = '' then
                        exit;
                    if Item.Get(Rec."Item No.") then
                        Page.Run(Page::"Item Card", Item);
                end;
            }

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

                                    warehouseActivityHeader.get(WarehouseActivityHeader.type::pick, WarehouseActivityLine."No.");
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

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        Item: Record Item;
        CommentText: Text;
    begin
        ClearCalculated();

        // Menge: in Whse Activity Line ist oft "Qty. (Base)" bzw. "Qty. to Handle" interessant.
        // Passe hier an, was ihr im Grid sehen wollt:
        Quantity := Rec."Qty. to Handle"; // oder Rec.Quantity, Rec."Qty. Outstanding", etc.

        // Artikelbeschreibung (sicherer über Item-Tabelle, falls Whse-Line Description leer/anders ist)
        if (Rec."Item No." <> '') and Item.Get(Rec."Item No.") then
            ItemDescription := Item.Description
        else
            ItemDescription := Rec.Description;

        // Nur wenn es aus einem Sales Order kommt
        // (Option/Enum kann je nach BC-Version leicht variieren – ggf. anpassen)
        if Rec."Source Type" <> 37 then
            exit;

        SalesOrderNo := Rec."Source No.";

        // Header holen
        if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then begin
            CustomerNo := SalesHeader."Sell-to Customer No.";
            CustomerName := SalesHeader."Sell-to Customer Name";
            ShipmentDate := SalesHeader."Shipment Date";
            ShippingAgentCode := SalesHeader."Shipping Agent Code";

            CalendarWeek := GetCalendarWeek(ShipmentDate);

            // Verkäufercode 1/2 + Zusatzstatus => HIER eure Custom-Felder einsetzen:
            SellerCode1 := SalesHeader."Salesperson Code";
            SellerCode2 := SalesHeader."Salesperson Code 2";
            ExtraStatus := format(SalesHeader.Zusatzstatus, 0, 1);
        end;

        // Nettobetrag möglichst exakt über Source Line No. (besser als Item-No-Filter!)
        // Falls Rec."Source Line No." gefüllt ist:
        if Rec."Source Line No." <> 0 then begin
            if SalesLine.Get(SalesLine."Document Type"::Order, SalesOrderNo, Rec."Source Line No.") then
                NetAmount := SalesLine.Amount;
        end else begin
            // Fallback: erste passende Sales Line zum Item
            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
            SalesLine.SetRange("Document No.", SalesOrderNo);
            SalesLine.SetRange("No.", Rec."Item No.");
            if SalesLine.FindFirst() then
                NetAmount := SalesLine.Amount;
        end;

        // Kommentar – Kunde (als Sales-Header-Kommentar aggregiert)
        // Alternativ: Customer Comment Lines / andere Logik möglich
        if SalesOrderNo <> '' then begin
            SalesCommentLine.Reset();
            SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Order);
            SalesCommentLine.SetRange("No.", SalesOrderNo);

            if SalesCommentLine.FindSet() then begin
                repeat
                    if SalesCommentLine.Comment <> '' then begin
                        if CommentText <> '' then
                            CommentText += ' | ';
                        CommentText += SalesCommentLine.Comment;
                    end;
                until SalesCommentLine.Next() = 0;

                CustomerComment := CommentText;
            end;
        end;
    end;

    local procedure ClearCalculated()
    begin
        SalesOrderNo := '';
        CustomerNo := '';
        CustomerName := '';
        ShipmentDate := 0D;
        ShippingAgentCode := '';
        ItemDescription := '';
        Quantity := 0;
        CalendarWeek := 0;
        CustomerComment := '';
        SellerCode1 := '';
        SellerCode2 := '';
        ExtraStatus := '';
        NetAmount := 0;
    end;

    local procedure OpenSalesOrder()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesOrderNo = '' then
            exit;

        if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then
            Page.Run(Page::"Sales Order", SalesHeader);
    end;

    local procedure OpenCustomer()
    var
        Customer: Record Customer;
    begin
        if CustomerNo = '' then
            exit;

        if Customer.Get(CustomerNo) then
            Page.Run(Page::"Customer Card", Customer);
    end;

    local procedure GetCalendarWeek(InputDate: Date): Integer
    var
        D: Integer;
        W: Integer;
        Y: Integer;
    begin
        if InputDate = 0D then
            exit(0);

        W := Date2DWY(InputDate, 2);
        exit(W);
    end;

    var
        SalesOrderNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text[100];
        ShipmentDate: Date;
        ShippingAgentCode: Code[10];
        ItemDescription: Text[100];
        Quantity: Decimal;
        CalendarWeek: Integer;
        CustomerComment: Text[250];
        SellerCode1: Code[20];
        SellerCode2: Code[20];
        ExtraStatus: Text[50];
        NetAmount: Decimal;
}
