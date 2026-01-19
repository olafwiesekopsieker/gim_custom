/// <summary>
/// Codeunit GIM Custom Events (ID 81200).
/// </summary>
codeunit 80000 "GIM Custom Events"
{

    [EventSubscriber(ObjectType::table, database::item, 'OnBeforeValidateEvent', 'Blocked', false, false)]
    local procedure OnBeforeValidateBlockedItem(CurrFieldNo: Integer; var Rec: Record Item; var xRec: Record Item)
    var
        UserSetup: record "User Setup";
    begin
        if not UserSetup.IsArtikelSperrenErlaubt() then
            error('Sie dürfen dieses Feld nicht ändern');


    end;






    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetPremiumExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetPremiumExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        TempApplicationAreaSetup.Advanced := true;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnSetExperienceTier', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnSetExperienceTier(ExperienceTierSetup: Record "Experience Tier Setup"; var TempApplicationAreaSetup: Record "Application Area Setup" temporary; var ApplicationAreasSet: Boolean)
    begin
        TempApplicationAreaSetup.Advanced := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetEssentialExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        TempApplicationAreaSetup.Advanced := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure ServiceHeaderOnAfterInsert(var Rec: Record "Service Header")

    begin
        if Rec.IsTemporary then
            exit;

        // Wenn du manuelle Aufträge eindeutig erkennen kannst, kannst du hier noch filtern
        // z. B. über Feld "Contract No." oder eine Source-Option.
        // Beispiel: Nur wenn kein Vertrag dahinter hängt:
        if Rec."Contract No." = '' then begin
            // Standard-Setup ist vielleicht AN, aber wir wollen im Auftrag default AUS
            Rec."Link Service to Service Item" := false;
            Rec.Modify(true);
        end;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Service Header", 'OnAfterModifyEvent', '', false, false)]
    // local procedure ServiceHeaderOnAfterMOdify(var Rec: Record "Service Header")

    // begin
    //     if Rec.IsTemporary then
    //         exit;

    //     // Wenn du manuelle Aufträge eindeutig erkennen kannst, kannst du hier noch filtern
    //     // z. B. über Feld "Contract No." oder eine Source-Option.
    //     // Beispiel: Nur wenn kein Vertrag dahinter hängt:
    //     if Rec."Contract No." = '' then begin
    //         // Standard-Setup ist vielleicht AN, aber wir wollen im Auftrag default AUS
    //         Rec."Link Service to Service Item" := false;
    //         Rec.Modify(true);
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Report, Report::"Create Contract Service Orders",
    //     'OnAfterCreateServiceHeader', '', false, false)]
    // local procedure ContractOnAfterCreateServiceOrderFromContract(var ServiceHeader: Record "Service Header")
    // begin
    //     // Bis hierhin hat Standard die Servicezeilen mit Serviceartikeln verknüpft.
    //     // Ab jetzt sollen neue Zeilen NICHT mehr zwingend verknüpft werden.
    //     ServiceHeader."Link Service to Service Item" := false;
    //     ServiceHeader.Modify(true);

    // end;

    [EventSubscriber(ObjectType::table, database::"Standard Service Item Gr. Code", 'OnBeforeInsertServiceLines', '', false, false)]
    local procedure OnBeforeInsertServiceLines(ServItemLine: Record "Service Item Line"; var IsHandled: Boolean)
    var
        ServiceHeader: Record "Service Header";

    begin
        If ServiceHeader.get(ServItemLine."Document Type", ServItemline."Document No.") then
            If ServiceHeader."Contract No." <> '' THEN begin
                Serviceheader."Link Service to Service Item" := true;
                ServiceHeader.modify(false);
            end;
    end;

    [EventSubscriber(ObjectType::report, Report::"Create Contract Service Orders", 'OnBeforeInsertServiceItemLine', '', false, false)]
    local procedure OnBeforeInsertServiceItemLine(var ServiceItemLine: Record "Service Item Line"; ServiceHeader: Record "Service Header"; ServiceContractHeader: Record "Service Contract Header"; ServiceContractLine: Record "Service Contract Line")
    begin
        If ServiceHeader.get(ServiceItemLine."Document Type", ServiceItemline."Document No.") then
            If ServiceHeader."Contract No." <> '' THEN begin
                Serviceheader."Link Service to Service Item" := true;
                ServiceHeader.modify(false);
            end;
    end;

    [EventSubscriber(ObjectType::report, Report::"Create Contract Service Orders", 'OnBeforeFindServiceItemLineOnCreateServiceHeader', '', false, false)]
    local procedure OnBeforeFindServiceItemLineOnCreateServiceHeader(var ServiceItemLine: Record "Service Item Line"; ServiceHeader: Record "Service Header"; ServiceContractHeader: Record "Service Contract Header"; ServiceContractLine: Record "Service Contract Line")
    begin


        Serviceheader."Link Service to Service Item" := true;
        ServiceHeader.modify(false);

    end;

    local procedure GetDuperthalServiceSetup(var DuperthalSetup: Record "gimDuperthal Service Setup"): Boolean
    begin
        exit(DuperthalSetup.Get('SETUP'));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Contract Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure ServiceContractHeaderOnBeforeInsert(var Rec: Record "Service Contract Header"; RunTrigger: Boolean)
    var
        DuperthalSetup: Record "gimDuperthal Service Setup";
    begin
        // Wenn keine Einrichtung -> einfach nichts machen (oder hier hart mit Error abbrechen, wenn gewünscht)
        if not GetDuperthalServiceSetup(DuperthalSetup) then
            exit;

        // Nur leere Felder vorbelegen, damit wir nichts überschreiben
        if Rec."Montage/h" = 0 then
            Rec."Montage/h" := DuperthalSetup."Montage/h";

        if Rec."Fahrt/h" = 0 then
            Rec."Fahrt/h" := DuperthalSetup."Fahrt/h";

        if Rec."Fahrt/km" = 0 then
            Rec."Fahrt/km" := DuperthalSetup."Fahrt/km";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInsertEvent', '', true, true)]
    local procedure SalesLine_OnBeforeInsert(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        Rec."gim Whse Source Subtype" := Rec."Document Type".AsInteger();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeModifyEvent', '', true, true)]
    local procedure SalesLine_OnBeforeModify(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if Rec."Document Type" <> xRec."Document Type" then
            Rec."gim Whse Source Subtype" := Rec."Document Type".AsInteger();
    end;



}


