/// <summary>
/// TableExtension gimNetVAPS SimProOrdr (ID 81201) extends Record NetVAPS SimProOrdr.
/// </summary>
tableextension 80001 "GIMNetVAPS SimPrdOrdr" extends "NetVAPS SimPrdOrdr"
{
    fields
    {
        field(80000; "Produktbuch.-gruppe (Artikel)"; Code[30])
        {
            Caption = 'Produktbuchungsgruppe (Artikel)';
            DataClassification = SystemMetadata;
        }
        field(80001; "Eventuelle Auftragsnr."; Code[50])
        {
            Caption = 'Eventuelle Auftragsnr.';
            DataClassification = SystemMetadata;
        }
        field(80002; Artikelkategoriecode; Code[50])
        {
            Caption = 'Artikelkategoriecode';
            DataClassification = SystemMetadata;
        }
        field(80003; Fertigungsgruppencode; code[50])
        {
            Caption = 'Fertigungsgruppencode';
            DataClassification = SystemMetadata;
        }

    }
}
