/// <summary>
/// Page "GIM_DatabaseTools" (ID 82001).
/// </summary>
page 80001 GIM_DatabaseTools
{
    ApplicationArea = All;
    Caption = 'GIM Database Tools';
    PageType = Card;
    SourceTable = "Customer";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ResetApplicationAreas)
            {
                ApplicationArea = All;
                Caption = 'Application Areas zurücksetzen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    ApplicationAreaSetup: record "Application Area Setup";
                    ExperienceTierSetup: record "Experience Tier Setup";
                begin
                    ApplicationAreaSetup.DELETEALL;
                    ExperienceTierSetup.DELETEALL;
                end;
            }

            action(AllItemsOnNoPlanningForEMAD)
            {
                ApplicationArea = All;
                Caption = 'Alle Artikel auf nicht berücksichtigen beim EMAD';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    item: record Item;

                begin
                    if userid = 'HEW\OLAF.WIESEKOPSIEKER' then
                        item.modifyall("NETVAPS Excl. From EMAD", true);
                end;
            }
        }
    }


}
