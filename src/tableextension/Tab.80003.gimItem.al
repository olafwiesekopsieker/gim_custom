tableextension 80003 gimItem extends Item
{
    fields
    {
        field(80000; gimNichtInEtagisPlanen; Boolean)
        {
            Caption = 'gimNichtInEtagisPlanen';
            DataClassification = SystemMetadata;
        }
        field(80004; gimRALCode; code[20])
        {
            Caption = 'RAL Farbcode';
            DataClassification = SystemMetadata;
            TableRelation = gimFarbe."RAL Code";

        }
    }
}
