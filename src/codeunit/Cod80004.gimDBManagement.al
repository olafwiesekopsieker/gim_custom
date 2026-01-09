codeunit 80004 gimDBManagement
{

    Subtype = Normal;
    Permissions = tabledata "Service Cr.Memo Line" = rimd;

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

    procedure DeleteOrphanedServicceCrMemoLines()
    var
        ServiceCrMemoLines: record "Service Cr.Memo Line";
    begin
        ServiceCrMemoLines.SETRANGE(type, ServiceCrMemoLines.type::item);
        ServiceCrMemoLines.Setrange("No.", '');
        ServiceCrMemoLines.DeleteAll(false);
    end;



}
