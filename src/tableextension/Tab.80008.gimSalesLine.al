tableextension 80008 gimSalesLine extends "Sales Line"
{
    fields
    {
        field(80000; "gimEingeplantes Lieferdatum"; Date)
        {
            Caption = 'Eingeplantes Lieferdatum';
            DataClassification = SystemMetadata;

        }

        field(80001; "Planned Shipment Date (etagis)"; Date)
        {
            Caption = 'Geplantes Warenausgangsdatum (etagis)';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                // Bei Änderung des geplanten Datums Status neu berechnen
                CalcEtagisStatus();

                // Header ebenfalls aktualisieren
                if GetSalesHeader(SalesHeader) then
                    SalesHeader.UpdateEtagisStatus();
            end;
        }

        field(80002; "Status (etagis)"; Option)
        {
            Caption = 'Status (etagis)';
            OptionMembers = Unkritisch,Ungeplant,Kritisch;
            OptionCaption = 'unkritisch,ungeplant,kritisch';
            Editable = false;
        }
    }

    local procedure CalcEtagisStatus()
    var
        DeliveryDate: Date;
    begin
        if "Planned Shipment Date (etagis)" = 0D then begin
            "Status (etagis)" := "Status (etagis)"::Ungeplant;
            exit;
        end;

        DeliveryDate := "Shipment Date";

        if "Planned Shipment Date (etagis)" > DeliveryDate then
            "Status (etagis)" := "Status (etagis)"::Kritisch
        else
            "Status (etagis)" := "Status (etagis)"::Unkritisch;
    end;

    local procedure GetSalesHeader(var SalesHeader: Record "Sales Header"): Boolean
    begin
        exit(SalesHeader.Get("Document Type", "Document No."));
    end;

    procedure RecalcEtagisStatusIfNeeded(): Boolean
    var
        OldStatus: Option Unkritisch,Ungeplant,Kritisch;
        DeliveryDate: Date;
        NewStatus: Option Unkritisch,Ungeplant,Kritisch;
    begin
        OldStatus := "Status (etagis)";

        // Status gemäß Logik neu bestimmen
        if "Planned Shipment Date (etagis)" = 0D then
            NewStatus := NewStatus::Ungeplant
        else begin
            // Vergleich gegen Zeilen-Liefer-/Warenausgangsdatum
            DeliveryDate := "Shipment Date"; // Fallback auf Header nicht nötig; BC pflegt i.d.R. je Zeile
            if ("Planned Shipment Date (etagis)" > DeliveryDate) and (DeliveryDate <> 0D) then
                NewStatus := NewStatus::Kritisch
            else
                NewStatus := NewStatus::Unkritisch;
        end;

        if NewStatus <> OldStatus then begin
            "Status (etagis)" := NewStatus;
            Modify(false); // kein Cascade-Trigger; wir rufen Header-Update separat
            exit(true);
        end;

        exit(false);
    end;
}
