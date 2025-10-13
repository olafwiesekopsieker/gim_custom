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
        field(80002; "gimEingeplanteStartzeit"; Datetime)
        {
            caption = 'Eingeplante Startzeit';
            Dataclassification = SystemMetadata;
        }
        field(80003; "gimEingeplanteEndzeit"; Datetime)
        {
            caption = 'Eingeplante Endzeit';
            Dataclassification = SystemMetadata;
        }
    }
}
