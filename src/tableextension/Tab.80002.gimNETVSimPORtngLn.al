/// <summary>
/// TableExtension gimNETVSimPORtngLn (ID 80002) extends Record NETVAPS SIMPrdOrdrRtngLn.
/// </summary>
tableextension 80002 gimNETVSimPORtngLn extends "NETVAPS SIMPrdOrdrRtngLn"
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
