tableextension 80008 gimSalesLine extends "Sales Line"
{
    fields
    {
        field(80000; "gimEingeplantes Lieferdatum"; Date)
        {
            Caption = 'Eingeplantes Lieferdatum';
            DataClassification = SystemMetadata;
        }
    }
}
