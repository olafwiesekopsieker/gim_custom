tableextension 80010 "gimSalesHeaderEtagis" extends "Sales Header"
{
    fields
    {
        field(80000; "Planned Shipment Date Min (etagis)"; Date)
        {
            Caption = 'Geplanter Warenausgang (min, etagis)';
            Editable = false;
        }
        field(80001; "Planned Shipment Date Max (etagis)"; Date)
        {
            Caption = 'Geplanter Warenausgang (max, etagis)';
            Editable = false;
        }
        field(80002; "Status (etagis)"; Option)
        {
            Caption = 'Status (etagis)';
            OptionMembers = Unkritisch,Ungeplant,Kritisch;
            OptionCaption = 'unkritisch,ungeplant,kritisch';
            Editable = false;
        }
    }

    procedure UpdateEtagisStatus()
    var
        SalesLine: Record "Sales Line";
        MinDate: Date;
        MaxDate: Date;
        HeaderStatus: Option Unkritisch,Ungeplant,Kritisch;
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");

        if SalesLine.FindSet() then begin
            MinDate := DMY2Date(31, 12, 9999);
            MaxDate := 0D;
            HeaderStatus := HeaderStatus::Unkritisch;

            repeat
                if SalesLine."Planned Shipment Date (etagis)" <> 0D then begin
                    if SalesLine."Planned Shipment Date (etagis)" < MinDate then
                        MinDate := SalesLine."Planned Shipment Date (etagis)";
                    if SalesLine."Planned Shipment Date (etagis)" > MaxDate then
                        MaxDate := SalesLine."Planned Shipment Date (etagis)";
                end;

                // Statushierarchie: unkritisch < ungeplant < kritisch
                case SalesLine."Status (etagis)" of
                    SalesLine."Status (etagis)"::Kritisch:
                        HeaderStatus := HeaderStatus::Kritisch;
                    SalesLine."Status (etagis)"::Ungeplant:
                        if HeaderStatus <> HeaderStatus::Kritisch then
                            HeaderStatus := HeaderStatus::Ungeplant;
                end;
            until SalesLine.Next() = 0;

            if MinDate = DMY2Date(31, 12, 9999) then
                MinDate := 0D;

            "Planned Shipment Date Min (etagis)" := MinDate;
            "Planned Shipment Date Max (etagis)" := MaxDate;
            "Status (etagis)" := HeaderStatus;
            Modify();
        end else begin
            // Keine Zeilen -> Felder zurücksetzen
            "Planned Shipment Date Min (etagis)" := 0D;
            "Planned Shipment Date Max (etagis)" := 0D;
            "Status (etagis)" := "Status (etagis)"::Ungeplant;
            Modify();
        end;
    end;
}