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


    [EventSubscriber(ObjectType::Table, Database::"NETVAPS SIMPrdOrdr", 'OnBeforeInsertEvent', '', true, true)]
    local procedure VAPSSimPrdOrdrOnBeforeInsert(var rec: record "NETVAPS SIMPrdOrdr")
    var
        item: record Item;
        POLine: record "Production Order";
    begin
        if rec."Source Type" = rec."source type"::Item then
            if rec."Source No." <> '' then begin
                IF not item.get(rec."Source No.") then
                    item.init;
                rec.Artikelkategoriecode := item."Item Category Code";
                rec."Produktbuch.-gruppe (Artikel)" := item."Gen. Prod. Posting Group";
                rec.Fertigungsgruppencode := item."Production Group Code";
            end;


    end;


    [EventSubscriber(ObjectType::Table, Database::"NETVAPS SIMPrdOrdrRtngLn", 'OnBeforeInsertEvent', '', true, true)]
    local procedure VAPSSimPORtLnOnBeforeInsert(var rec: record "NETVAPS SIMPrdOrdrRtngLn")
    var
        PO: record "Production Order";
        item: record "Item";
    begin
        if not po.GET(rec.Status, rec."Prod. Order No.") then
            po.init;
        if po."Source Type" = po."source type"::Item then
            if po."Source No." <> '' then begin
                IF not item.get(po."Source No.") then
                    item.init;
                rec.Artikelkategoriecode := item."Item Category Code";
                rec."Produktbuch.-gruppe (Artikel)" := item."Gen. Prod. Posting Group";
                rec.Fertigungsgruppencode := item."Production Group Code";
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetPremiumExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetPremiumExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        TempApplicationAreaSetup.Advanced := true;
    end;
}


