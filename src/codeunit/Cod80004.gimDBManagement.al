codeunit 80004 gimDBManagement
{

    Subtype = Normal;

    procedure RunDisableAllJobQueues()
    var
        Company: Record Company;
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if Company.FindSet() then
            repeat
                // In Company wechseln
                JobQueueEntry.ChangeCompany(Company.Name);

                if JobQueueEntry.FindSet(true) then
                    repeat

                        JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
                        JobQueueEntry.Modify(true);
                    until JobQueueEntry.Next() = 0;
            until Company.Next() = 0;
    end;

}
