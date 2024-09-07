/// <summary>
/// TableExtension gimNetVAPS SimProOrdr (ID 81201) extends Record NetVAPS SimProOrdr.
/// </summary>
tableextension 81201 "GIMNetVAPS SimPrdOrdr" extends "NetVAPS SimPrdOrdr"
{
    fields
    {
        field(81200; "Produktbuch.-gruppe (Artikel)"; Code[30])
        {
            Caption = 'Produktbuchungsgruppe (Artikel)';
            DataClassification = SystemMetadata;
        }
        field(81201; "Eventuelle Auftragsnr."; Code[50])
        {
            Caption = 'Eventuelle Auftragsnr.';
            DataClassification = SystemMetadata;
        }
        field(81202; Artikelkategoriecode; Code[50])
        {
            Caption = 'Artikelkategoriecode';
            DataClassification = SystemMetadata;
        }

    }
}
