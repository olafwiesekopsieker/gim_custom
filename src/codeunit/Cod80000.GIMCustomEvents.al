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

    [EventSubscriber(ObjectType::Report, Report::"Create Contract Service Orders",
        'OnAfterCreateServiceHeader', '', false, false)]
    local procedure ContractOnAfterCreateServiceOrderFromContract(var ServiceHeader: Record "Service Header")
    begin
        // Bis hierhin hat Standard die Servicezeilen mit Serviceartikeln verknüpft.
        // Ab jetzt sollen neue Zeilen NICHT mehr zwingend verknüpft werden.
        ServiceHeader."Link Service to Service Item" := false;
        ServiceHeader.Modify(true);

    end;



}


