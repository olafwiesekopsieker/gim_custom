/// <summary>
/// PageExtension gimNETVOpSelector (ID 80002) extends Record NETVAPS Operation Selector.
/// </summary>
pageextension 80002 gimNETVOpSelector extends "NETVAPS Operation Selector"
{
    layout
    {
        addlast(RepeaterGroup)
        {
            field("Produktbuch.-gruppe (Artikel)"; Rec."Produktbuch.-gruppe (Artikel)")
            {
                ApplicationArea = all;
            }
            field("Eventuelle Auftragsnr."; Rec."Eventuelle Auftragsnr.")
            {
                ApplicationArea = all;
            }
            field(Artikelkategoriecode; Rec.Artikelkategoriecode)
            {
                ApplicationArea = all;
            }
            field(Fertigungsgruppencode; Rec.Fertigungsgruppencode)
            {
                ApplicationArea = all;
            }

        }

    }
}
