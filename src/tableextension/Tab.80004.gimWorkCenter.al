/// <summary>
/// TableExtension gimWorkCenter (ID 80004) extends Record Work Center.
/// </summary>
tableextension 80004 gimWorkCenter extends "Work Center"
{
    fields
    {
        field(80000; gimSortOrderEtagis; Integer)
        {
            Caption = 'Sortierreihenfolge Etagis';
            DataClassification = SystemMetadata;
        }
        field(80001; gimRessourcentyp; enum gimRessourcentyp)
        {
            Caption = 'Ressourcentyp';
            DataClassification = SystemMetadata;
        }
        field(80002; gimVerplanungsart; enum gimVerplanungsart)
        {
            Caption = 'Verplanungsart';
            DataClassification = SystemMetadata;
        }



    }
}
