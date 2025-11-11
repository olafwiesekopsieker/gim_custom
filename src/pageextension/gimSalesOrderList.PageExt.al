pageextension 80026 "Sales Order List Ext" extends "Sales Order List"
{
    actions
    {
        addlast(processing)
        {
            action(CaptureDeliverySignatures)
            {
                Caption = 'Unterschriften erfassen';
                ApplicationArea = All;
                Image = Signature;

                trigger OnAction()
                var
                    SelHdr: Record "Sales Header";
                    TmpHdr: Record "Sales Header";
                    CapPage: Page "gimDeliverySignatureCapture";
                    OrdersListText: Text;
                    SysIds: List of [Guid];
                    Res: Action;
                    B64: Text;
                    SigDate: Date;
                    Fwd: Text;
                    Plate: Code[20];
                    SigRec: Record "gimDeliverySignature";
                    TempBlob: Codeunit "Temp Blob";
                    Base64Conv: Codeunit "Base64 Convert";
                    OutS: OutStream;
                    InS: InStream;
                    i: Integer;
                    id: Guid;
                    Cap: Page "gimDeliverySignatureCapture";
                begin
                    // Auswahl holen (oder aktuellen Datensatz verwenden)
                    CurrPage.SetSelectionFilter(SelHdr);
                    BuildOrdersListAndSysIds(SelHdr, OrdersListText, SysIds);

                    // 2) Liste in die Dialog-Page setzen und öffnen
                    CapPage.SetOrdersText(OrdersListText);
                    cappage.SetTargetSysIds(SysIds);
                    // (Optional) saubere Transaktionsgrenze setzen
                    COMMIT;
                    Res := CapPage.RunModal();
                    if Res <> Action::OK then
                        exit;

                    Message('Für %1 Auftrag/Aufträge erfasst: %2', SysIds.Count(), OrdersListText);
                end;
            }
        }
    }

    local procedure BuildOrdersListAndSysIds(var SelHdr: Record "Sales Header"; var OrdersListText: Text; var SysIds: List of [Guid]): Integer
    var
        cnt: Integer;
    begin
        OrdersListText := '';
        cnt := 0;

        // Erwartung: CurrPage.SetSelectionFilter(SelHdr) wurde vorher aufgerufen
        if SelHdr.FindSet(true, false) then
            repeat
                if SelHdr."Document Type" = SelHdr."Document Type"::Order then begin
                    // Liste aufbauen: "No." kommasepariert
                    if OrdersListText <> '' then
                        OrdersListText += ', ';
                    OrdersListText += SelHdr."No.";

                    // SystemId sammeln
                    SysIds.Add(SelHdr.SystemId);

                    cnt += 1;
                end;
            until SelHdr.Next() = 0;

        exit(cnt);
    end;


}