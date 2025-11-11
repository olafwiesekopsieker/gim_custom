codeunit 80003 gimEtagisRedirectHelper
{
    SingleInstance = true;

    // ### KONFIGURATION: Etagis-Service-User hier eintragen
    // z.B. 'ETAGIS_SVC' oder die eindeutige UserId des Dienstkontos


    procedure IsFromEtagis(): Boolean
    var
        EtagisServiceUserId: Code[50];
    begin
        EtagisServiceUserID := 'ETAGIS';
        exit(UserId = EtagisServiceUserId);
    end;

    procedure RedirectPlannedOnModify(
        var RecStarting: DateTime; var RecEnding: DateTime;
        xStarting: DateTime; xEnding: DateTime;
        var PlannedStarting: DateTime; var PlannedEnding: DateTime)
    begin
        // Neuer Start -> in Planned kopieren, Standard zurück auf xRec
        if RecStarting <> xStarting then begin
            PlannedStarting := RecStarting;
            RecStarting := xStarting;
        end;

        // Neues Ende -> in Planned kopieren, Standard zurück auf xRec
        if RecEnding <> xEnding then begin
            PlannedEnding := RecEnding;
            RecEnding := xEnding;
        end;
    end;

}
