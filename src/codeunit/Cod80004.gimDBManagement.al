codeunit 80004 gimDBManagement
{

    Subtype = Normal;
    Permissions = tabledata "Service Cr.Memo Line" = rimd,
                  tabledata "Purchase header" = rimd,
                  tabledata "Purchase line" = rimd;

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

    procedure DeleteEinkBestellungen()
    var
        PurchHeader: record "Purchase header";
        PurchLine: Record "Purchase Line";
    begin
        ////EBS-170000..EBS-24-0036
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("No.", 'EBS-170000', 'EBS-24-0036');

        Purchline.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        Purchline.SETRANGE("Document No.", 'EBS-170000', 'EBS-24-0036');

        Purchline.deleteall(false);
        Purchheader.deleteall(false);
    end;



}
