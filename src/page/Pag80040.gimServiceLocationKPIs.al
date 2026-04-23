page 80040 "gim Service Location KPIs"
{
    PageType = Worksheet;
    Caption = 'Service Location KPIs';
    SourceTable = "gim Service Loc. KPI Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Service;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(DateFilter1Field; DateFilter1)
                {
                    Caption = 'Date Filter 1 (Comparison Period)';
                    ApplicationArea = All;
                    ToolTip = 'e.g. previous year (for Posted Invoices)';
                    
                    trigger OnValidate()
                    begin
                        CalculateData();
                    end;
                }
                field(DateFilter2Field; DateFilter2)
                {
                    Caption = 'Date Filter 2 (Current Period)';
                    ApplicationArea = All;
                    ToolTip = 'e.g. current year (for Invoices, Quotes, Orders)';

                    trigger OnValidate()
                    begin
                        CalculateData();
                    end;
                }
            }
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ship-to code.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the ship-to address.';
                }
                field("Invoices Count 1"; Rec."Invoices Count 1")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the number of posted service invoices in period 1.';
                    
                    trigger OnDrillDown()
                    begin
                        ShowPostedInvoices(DateFilter1);
                    end;
                }
                field("Invoices Count 2"; Rec."Invoices Count 2")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the number of posted service invoices in period 2.';
                    
                    trigger OnDrillDown()
                    begin
                        ShowPostedInvoices(DateFilter2);
                    end;
                }
                field("Quotes Count"; Rec."Quotes Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of service quotes in period 2.';
                    
                    trigger OnDrillDown()
                    begin
                        ShowServiceDocs(Enum::"Service Document Type"::Quote, DateFilter2);
                    end;
                }
                field("Orders Count"; Rec."Orders Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of service orders in period 2.';
                    
                    trigger OnDrillDown()
                    begin
                        ShowServiceDocs(Enum::"Service Document Type"::Order, DateFilter2);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Calculate)
            {
                Caption = 'Calculate';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Calculate the numbers based on the specified filters.';

                trigger OnAction()
                begin
                    CalculateData();
                end;
            }
        }
    }

    var
        DateFilter1: Text;
        DateFilter2: Text;

    local procedure CalculateData()
    var
        QInvoices1: Query "gim Count Serv. Invoices";
        QInvoices2: Query "gim Count Serv. Invoices";
        QQuotes: Query "gim Count Serv. Quotes";
        QOrders: Query "gim Count Serv. Orders";
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
    begin
        Rec.Reset();
        Rec.DeleteAll();

        // 1. Rechnungen fuer DateFilter 1
        if DateFilter1 <> '' then
            QInvoices1.SetFilter(Posting_Date, DateFilter1);
        
        if QInvoices1.Open() then
            while QInvoices1.Read() do
                UpdateBuffer(QInvoices1.Customer_No_, QInvoices1.Ship_to_Code, QInvoices1.InvoiceCount, 0, 0, 0);

        // 2. Rechnungen fuer DateFilter 2
        if DateFilter2 <> '' then
            QInvoices2.SetFilter(Posting_Date, DateFilter2);
        
        if QInvoices2.Open() then
            while QInvoices2.Read() do
                UpdateBuffer(QInvoices2.Customer_No_, QInvoices2.Ship_to_Code, 0, QInvoices2.InvoiceCount, 0, 0);

        // 3. Angebote fuer DateFilter 2
        if DateFilter2 <> '' then
            QQuotes.SetFilter(Document_Date, DateFilter2);
        
        if QQuotes.Open() then
            while QQuotes.Read() do
                UpdateBuffer(QQuotes.Customer_No_, QQuotes.Ship_to_Code, 0, 0, QQuotes.QuoteCount, 0);

        // 4. Auftraege fuer DateFilter 2
        if DateFilter2 <> '' then
            QOrders.SetFilter(Document_Date, DateFilter2);
        
        if QOrders.Open() then
            while QOrders.Read() do
                UpdateBuffer(QOrders.Customer_No_, QOrders.Ship_to_Code, 0, 0, 0, QOrders.OrderCount);


        // Namen aktualisieren am Ende  
        if Rec.FindSet() then
            repeat
                if Customer.Get(Rec."Customer No.") then
                    Rec."Customer Name" := Customer.Name;
                    
                if Rec."Ship-to Code" <> '' then begin
                    if ShipToAddress.Get(Rec."Customer No.", Rec."Ship-to Code") then
                        Rec."Ship-to Name" := ShipToAddress.Name;
                end else
                    Rec."Ship-to Name" := 'Hauptadresse'; 
                
                Rec.Modify();
            until Rec.Next() = 0;

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    local procedure UpdateBuffer(CustNo: Code[20]; ShipTo: Code[20]; InvCount1: Integer; InvCount2: Integer; QuoteCount: Integer; OrderCount: Integer)
    begin
        if not Rec.Get(CustNo, ShipTo) then begin
            Rec.Init();
            Rec."Customer No." := CustNo;
            Rec."Ship-to Code" := ShipTo;
            Rec.Insert();
        end;

        if InvCount1 <> 0 then Rec."Invoices Count 1" += InvCount1;
        if InvCount2 <> 0 then Rec."Invoices Count 2" += InvCount2;
        if QuoteCount <> 0 then Rec."Quotes Count" += QuoteCount;
        if OrderCount <> 0 then Rec."Orders Count" += OrderCount;
        Rec.Modify();
    end;

    local procedure ShowPostedInvoices(SelectedDateFilter: Text)
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
    begin
        ServiceInvoiceHeader.SetRange("Customer No.", Rec."Customer No.");
        
        if Rec."Ship-to Code" <> '' then
            ServiceInvoiceHeader.SetRange("Ship-to Code", Rec."Ship-to Code")
        else
            ServiceInvoiceHeader.SetFilter("Ship-to Code", '%1', '');

        if SelectedDateFilter <> '' then
            ServiceInvoiceHeader.SetFilter("Posting Date", SelectedDateFilter);

        Page.Run(Page::"Posted Service Invoices", ServiceInvoiceHeader);
    end;

    local procedure ShowServiceDocs(DocType: Enum "Service Document Type"; SelectedDateFilter: Text)
    var
        ServiceHeader: Record "Service Header";
    begin
        ServiceHeader.SetRange("Document Type", DocType);
        ServiceHeader.SetRange("Customer No.", Rec."Customer No.");
        
        if Rec."Ship-to Code" <> '' then
            ServiceHeader.SetRange("Ship-to Code", Rec."Ship-to Code")
        else
            ServiceHeader.SetFilter("Ship-to Code", '%1', '');

        if SelectedDateFilter <> '' then
            ServiceHeader.SetFilter("Document Date", SelectedDateFilter);

        if DocType = "Service Document Type"::Quote then
            Page.Run(Page::"Service Quotes", ServiceHeader)
        else if DocType = "Service Document Type"::Order then
            Page.Run(Page::"Service Orders", ServiceHeader);
    end;
}
