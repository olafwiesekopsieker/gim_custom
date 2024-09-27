/// <summary>
/// PageExtension gim2UserSetup (ID 81200) extends Record User Setup.
/// </summary>
pageextension 80000 GIM2UserSetup extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {

            field("gimArtikel sperren erlaubt"; Rec."gimArtikel sperren erlaubt")
            {
                ApplicationArea = All;
                caption = 'Artikel sperren erlaubt';
                ToolTip = 'Benutzer mit SUPER-Rechten können hier festlegen, ob ein User berechtigt ist, Artikel zu sperren oder entsperren', Comment = '%';
            }
        }
    }
}
