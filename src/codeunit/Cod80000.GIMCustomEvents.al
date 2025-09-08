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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetEssentialExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        TempApplicationAreaSetup.Advanced := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnSetExperienceTier', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnSetExperienceTier(ExperienceTierSetup: Record "Experience Tier Setup"; var TempApplicationAreaSetup: Record "Application Area Setup" temporary; var ApplicationAreasSet: Boolean)
    begin
        TempApplicationAreaSetup.Advanced := true;
    end;
}


