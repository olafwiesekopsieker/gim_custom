tableextension 80006 gimFAZeile extends "Prod. Order Line"
{
    fields
    {
        field(80000; Produktionszieltermin; Date)
        {
            Caption = 'Produktionszieltermin';
            DataClassification = SystemMetadata;
        }
        field(80001; "etagis Data"; Text[400])
        {
            Caption = 'etagis Data';
            DataClassification = SystemMetadata;
        }
    }
}
