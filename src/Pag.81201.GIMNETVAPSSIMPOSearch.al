/// <summary>
/// PageExtension GIMNETVAPS SIM PO Search (ID 81201) extends Record NETVAPS Sim PO Search.
/// </summary>
pageextension 81201 "GIMNETVAPS SIM PO Search" extends "NETVAPS Sim PO Search"
{
    layout
    {
        addlast(Control1)
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
        }

    }

}
