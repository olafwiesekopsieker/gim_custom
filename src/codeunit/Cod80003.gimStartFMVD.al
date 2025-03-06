/// <summary>
/// Codeunit gimStartEMAD (ID 80003).
/// </summary>
codeunit 80003 gimStartEMAD
{
    permissions = tabledata "Change Log Setup" = m;
    tableno = "Job Queue Entry";

    trigger onrun()
    var
        ChangeLogSetup: record "Change Log Setup";

        EMADJobqueue: Codeunit "NETVAPS Calc. EMAD JobQueue";
    begin

        if ChangeLogSetup.get then BEGIN
            if ChangelogSetup."Change Log Activated" then BEGIN
                ChangelogSetup.VALIDATE("Change log Activated", false);
                changelogsetup.modify;
                EMADJobqueue.Run(rec);
                ChangelogSetup.Validate("Change Log Activated", true);
                changelogsetup.modify;
            end ELSE
                EMADJobQueue.run(rec);

        END;
    end;

    procedure StartFMVDFromPage()
    var
      ChangeLogSetup: record "Change Log Setup";
      EMAD: Codeunit "NETVAPS EMAD Management";
    begin
          if ChangeLogSetup.get then BEGIN
            if ChangelogSetup."Change Log Activated" then BEGIN
                ChangelogSetup.VALIDATE("Change log Activated", false);
                changelogsetup.modify;
                EMAD.Run();
                ChangelogSetup.Validate("Change Log Activated", true);
                changelogsetup.modify;
            end ELSE
                EMAD.run();

        END; 
    end;


}
