/// <summary>
/// Codeunit GIM Custom Events (ID 81200).
/// </summary>
codeunit 81200 "GIM Custom Events"
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
    begin
        if rec."Source Type" = rec."source type"::Item then
            if rec."Source No." <> '' then begin
                IF not item.get(rec."Source No.") then
                    item.init;
                rec.Artikelkategoriecode := item."Item Category Code";
                rec."Produktbuch.-gruppe (Artikel)" := item."Gen. Prod. Posting Group";
            end;

    end;


}


