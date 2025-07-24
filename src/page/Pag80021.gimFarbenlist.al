page 80021 gimFarbenlist
{
    ApplicationArea = All;
    Caption = 'Farbenliste';
    PageType = List;
    SourceTable = gimFarbe;
    UsageCategory = Administration;
    CardPageId = gimFarben;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("RAL Code"; Rec."RAL Code")
                {
                    ToolTip = 'Specifies the value of the RAL Code field.', Comment = '%';
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ToolTip = 'Specifies the value of the Beschreibung field.', Comment = '%';

                }
                field(R; Rec.R)
                {
                    ToolTip = 'Specifies the value of the R field.', Comment = '%';
                }
                field(G; Rec.G)
                {
                    ToolTip = 'Specifies the value of the G field.', Comment = '%';
                }
                field(B; Rec.B)
                {
                    ToolTip = 'Specifies the value of the B field.', Comment = '%';
                }
                field(RGB; Rec.RGB)
                {
                    ToolTip = 'Specifies the value of the RGB field.', Comment = '%';
                }
                field("Priorität"; Rec."Priorität")
                {
                    ToolTip = 'Specifies the value of the Priorität field.', Comment = '%';
                }
                field(Luminanz; Rec.Luminanz)
                {
                    ToolTip = 'Specifies the value of the Luminanz field.', Comment = '%';
                }
            }
        }
    }
}
