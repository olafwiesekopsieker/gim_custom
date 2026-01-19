page 80028 "gim Reg. Whse Act. Sales View"
{
    PageType = List;
    SourceTable = "Registered Whse. Activity Line";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Registrierte Kommissionierzeilen – Verkaufssicht';
    
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
                    Caption = 'Reg. Whse Activity No.';
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
                begin
                    OpenItem();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
    begin
        ClearCalculated();

        // Menge: Bei registrierten Zeilen nehmen wir Quantity
        Quantity := Rec.Quantity;

        // Artikelbeschreibung
        if (Rec."Item No." <> '') and Item.Get(Rec."Item No.") then
            ItemDescription := Item.Description
        else
            ItemDescription := Rec.Description;

        // Nur wenn es aus einem Sales Order kommt (Source Type 37 = Sales Line)
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

            SellerCode1 := SalesHeader."Salesperson Code";
            SellerCode2 := SalesHeader."Salesperson Code 2";
            ExtraStatus := format(SalesHeader.Zusatzstatus, 0, 1);
        end;

        // Nettobetrag ermitteln
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
    
    local procedure OpenItem()
    var
        Item: Record Item;
    begin
        if Rec."Item No." = '' then
            exit;
        if Item.Get(Rec."Item No.") then
            Page.Run(Page::"Item Card", Item);
    end;

    local procedure GetCalendarWeek(InputDate: Date): Integer
    var
        W: Integer;
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
        SellerCode1: Code[20];
        SellerCode2: Code[20];
        ExtraStatus: Text[50];
        NetAmount: Decimal;
}
