table 80003 "gimDuperthal Service Setup"
{
    Caption = 'Düperthal Service Einrichtung';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }

        field(10; "Montage/h"; Decimal)
        {
            Caption = 'Montage/h (Standard)';
        }

        field(20; "Fahrt/h"; Decimal)
        {
            Caption = 'Fahrt/h (Standard)';
        }

        field(30; "Fahrt/km"; Decimal)
        {
            Caption = 'Fahrt/km (Standard)';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'SETUP';
    end;
}
