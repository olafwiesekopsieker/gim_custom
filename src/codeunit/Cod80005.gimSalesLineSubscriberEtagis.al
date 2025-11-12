codeunit 80005 "gimSalesLineSubscribersEtagis"
{
    SingleInstance = true; // für Guard-Flag pro Session

    var
        IsRunning: Boolean;

    local procedure EnterGuard(): Boolean
    begin
        if IsRunning then
            exit(false);
        IsRunning := true;
        exit(true);
    end;

    local procedure ExitGuard()
    begin
        IsRunning := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure SalesLine_OnAfterInsert(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        if not EnterGuard() then
            exit;
        // Immer Status prüfen (z.B. wenn etagis direkt initial füllt)
        Rec.RecalcEtagisStatusIfNeeded();

        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            SalesHeader.UpdateEtagisStatus();

        ExitGuard();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure SalesLine_OnAfterModify(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
        RelevantChanged: Boolean;
    begin
        if not EnterGuard() then
            exit;

        // Nur arbeiten, wenn relevante Felder betroffen waren
        RelevantChanged :=
            (Rec."Planned Shipment Date (etagis)" <> xRec."Planned Shipment Date (etagis)") or
            (Rec."Shipment Date" <> xRec."Shipment Date") or
            (Rec."Status (etagis)" <> xRec."Status (etagis)"); // falls extern schon gesetzt wurde

        if RelevantChanged then begin
            // Linie konsistent machen
            Rec.RecalcEtagisStatusIfNeeded();

            // Header neu aggregieren
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
                SalesHeader.UpdateEtagisStatus();
        end;

        ExitGuard();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure SalesLine_OnAfterDelete(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        if not EnterGuard() then
            exit;

        // Nach Löschung Zeilenbereich aggregieren (Min/Max/Status können sich ändern)
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            SalesHeader.UpdateEtagisStatus();

        ExitGuard();
    end;
}