codeunit 80010 "gimLeadNoMgt"
{
    // Sales Post Subscribers

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertShipmentHeader', '', false, false)]
    local procedure OnAfterInsertShipmentHeader(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."LEAD Nummer" <> '' then begin
            SalesShipmentHeader."LEAD Nummer" := SalesHeader."LEAD Nummer";
            SalesShipmentHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertInvoiceHeader', '', false, false)]
    local procedure OnAfterInsertInvoiceHeader(var SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    begin
        if SalesHeader."LEAD Nummer" <> '' then begin
            SalesInvHeader."LEAD Nummer" := SalesHeader."LEAD Nummer";
            SalesInvHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertCrMemoHeader', '', false, false)]
    local procedure OnAfterInsertCrMemoHeader(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."LEAD Nummer" <> '' then begin
            SalesCrMemoHeader."LEAD Nummer" := SalesHeader."LEAD Nummer";
            SalesCrMemoHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertReturnReceiptHeader', '', false, false)]
    local procedure OnAfterInsertReturnReceiptHeader(var ReturnReceiptHeader: Record "Return Receipt Header"; SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."LEAD Nummer" <> '' then begin
            ReturnReceiptHeader."LEAD Nummer" := SalesHeader."LEAD Nummer";
            ReturnReceiptHeader.Modify();
        end;
    end;

    // Service Post Subscribers

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnBeforeServiceShptHeaderInsert', '', false, false)]
    local procedure OnAfterInsertServiceShipmentHeader(var ServiceShipmentHeader: Record "Service Shipment Header"; ServiceHeader: Record "Service Header")
    begin
        if ServiceHeader."LEAD Nummer" <> '' then begin
            ServiceShipmentHeader."LEAD Nummer" := ServiceHeader."LEAD Nummer";
            // ServiceShipmentHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnBeforeServiceInvHeaderInsert', '', false, false)]
    local procedure OnAfterInsertServiceInvoiceHeader(var ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceHeader: Record "Service Header")
    begin
        if ServiceHeader."LEAD Nummer" <> '' then begin
            ServiceInvoiceHeader."LEAD Nummer" := ServiceHeader."LEAD Nummer";
            // ServiceInvoiceHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnBeforeServiceCrMemoHeaderInsert', '', false, false)]
    local procedure OnAfterInsertServiceCrMemoHeader(var ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ServiceHeader: Record "Service Header")
    begin
        if ServiceHeader."LEAD Nummer" <> '' then begin
            ServiceCrMemoHeader."LEAD Nummer" := ServiceHeader."LEAD Nummer";
            // ServiceCrMemoHeader.Modify();
        end;
    end;
}
