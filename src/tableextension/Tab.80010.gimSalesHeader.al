tableextension 80010 "gimSalesHeaderEtagis" extends "Sales Header"
{
    fields
    {
        field(80000; "Plan Shipm. Date Min (etagis)"; Date)
        {
            Caption = 'Geplanter Warenausgang (min, etagis)';
            Editable = false;
        }
        field(80001; "Plan Shipm. Date Max (etagis)"; Date)
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
        field(80003; "LEAD Nummer"; Text[50])
        {
            Caption = 'LEAD Nummer';
            DataClassification = ToBeClassified;
        }

        field(80004; "gimAvailabilityStatus"; Option)
        {
            Caption = 'Verfügbarkeitsstatus (Fertigware)';
            OptionMembers = "Incomplete","Partially Available","Fully Available";
            OptionCaption = 'Unvollständig,Teilweise verfügbar,Vollständig verfügbar';
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

            "Plan Shipm. Date Min (etagis)" := MinDate;
            "Plan Shipm. Date Max (etagis)" := MaxDate;
            "Status (etagis)" := HeaderStatus;

            // Auch Verfügbarkeit prüfen
            UpdateAvailabilityStatus(SalesLine);

            Modify();
        end else begin
            // Keine Zeilen -> Felder zurücksetzen
            "Plan Shipm. Date Min (etagis)" := 0D;
            "Plan Shipm. Date Max (etagis)" := 0D;
            "Status (etagis)" := "Status (etagis)"::Ungeplant;
            "gimAvailabilityStatus" := "gimAvailabilityStatus"::Incomplete;
            Modify();
        end;
    end;

    procedure UpdateAvailabilityStatus(var SalesLine: Record "Sales Line")
    var
        LocalSalesLine: Record "Sales Line";
        Item: Record Item;
        TotalLines: Integer;
        FullyAvailableLines: Integer;
        PartiallyAvailableLines: Integer;
    begin
        // Reuse SalesLine record set if possible, but safely iterate
        LocalSalesLine.CopyFilters(SalesLine);
        LocalSalesLine.SetRange(Type, LocalSalesLine.Type::Item); // Only Items

        TotalLines := 0;
        FullyAvailableLines := 0;
        PartiallyAvailableLines := 0;

        if LocalSalesLine.FindSet() then
            repeat
                // Only consider lines with outstanding quantity
                if LocalSalesLine."Outstanding Quantity" > 0 then begin
                    // Check if Item is Inventory-relevant
                    if Item.Get(LocalSalesLine."No.") then begin
                        if Item.Type = Item.Type::Inventory then begin
                            TotalLines += 1;
                            if CheckLineAvailability(LocalSalesLine) then
                                FullyAvailableLines += 1
                            else
                                // Logic could be more complex (partial), but for now if ANY reservation exists?
                                // The requirement is strict: "nur ... fertig produziert".
                                // Let's assume binary per line for "Fully Available Logic" on header.
                                // But wait, if 5/10 are reserved, is it partial? Yes.
                                // For the header "Traffic Light", let's count "Fully Covered Lines".
                                if GetReservedFinishedQty(LocalSalesLine) > 0 then
                                    PartiallyAvailableLines += 1;
                        end;
                    end;
                end;
            until LocalSalesLine.Next() = 0;

        if TotalLines = 0 then begin
            "gimAvailabilityStatus" := "gimAvailabilityStatus"::Incomplete; // Or "Not Applicable"?
            exit;
        end;

        if FullyAvailableLines = TotalLines then
            "gimAvailabilityStatus" := "gimAvailabilityStatus"::"Fully Available"
        else
            if (FullyAvailableLines > 0) or (PartiallyAvailableLines > 0) then
                "gimAvailabilityStatus" := "gimAvailabilityStatus"::"Partially Available"
            else
                "gimAvailabilityStatus" := "gimAvailabilityStatus"::Incomplete;
    end;

    local procedure CheckLineAvailability(SalesLine: Record "Sales Line"): Boolean
    var
        ReservedQty: Decimal;
    begin
        ReservedQty := GetReservedFinishedQty(SalesLine);
        // Use Base Units for comparison to avoid rounding issues if possible, 
        // but SalesLine."Outstanding Quantity" is in Sales Unit.
        // Reservation Entry is in Base.
        // SalesLine."Outstanding Qty. (Base)" is safer.

        if SalesLine."Outstanding Qty. (Base)" <= ReservedQty then
            exit(true);

        exit(false);
    end;

    local procedure GetReservedFinishedQty(SalesLine: Record "Sales Line"): Decimal
    var
        ReservEntry: Record "Reservation Entry";
        EntrySummary: Record "Entry Summary";
        // We can't use Entry Summary efficiently here for specific linkage.
        // Better navigate Reservation Entries.
        //ResQry: Query "Reservation Entries"; 
        // Query object might not exist or be usable. 
        // Classic approach: Find Res Entry for Sales Line, then find counterpart.

        ResEntryMine: Record "Reservation Entry";
        ResEntryOther: Record "Reservation Entry";
        TotalReserved: Decimal;
    begin
        TotalReserved := 0;

        ResEntryMine.SetRange("Source Type", Database::"Sales Line");
        ResEntryMine.SetRange("Source Subtype", SalesLine."Document Type");
        ResEntryMine.SetRange("Source ID", SalesLine."Document No.");
        ResEntryMine.SetRange("Source Ref. No.", SalesLine."Line No.");
        ResEntryMine.SetRange("Reservation Status", ResEntryMine."Reservation Status"::Reservation);

        // Optimize: we don't strictly need to iterate Mine if we know how Res Entries work.
        // But entries are paired by "Entry No.".
        if ResEntryMine.FindSet() then
            repeat
                // Find the Positive entry with same Entry No.
                ResEntryOther.SetRange("Entry No.", ResEntryMine."Entry No.");
                ResEntryOther.SetFilter("Source ID", '<>%1', SalesLine."Document No."); // Just to be safe not to find self
                ResEntryOther.SetRange(Positive, true);
                ResEntryOther.SetRange("Source Type", Database::"Item Ledger Entry"); // MUST BE ILE (Finished/Stock)

                if ResEntryOther.FindSet() then
                    repeat
                        TotalReserved += ResEntryOther."Quantity (Base)";
                    until ResEntryOther.Next() = 0;

            until ResEntryMine.Next() = 0;

        exit(TotalReserved);
    end;
}