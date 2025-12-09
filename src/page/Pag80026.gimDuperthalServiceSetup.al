page 80026 "gimDuperthal Service Setup"
{
    PageType = Card;
    SourceTable = "gimDuperthal Service Setup";
    Caption = 'Düperthal Service Einrichtung';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Montage/h"; Rec."Montage/h")
                {
                    ApplicationArea = All;
                }
                field("Fahrt/h"; Rec."Fahrt/h")
                {
                    ApplicationArea = All;
                }
                field("Fahrt/km"; Rec."Fahrt/km")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('SETUP') then begin
            Rec.Init();
            Rec."Primary Key" := 'SETUP';
            Rec.Insert();
        end;
    end;
}