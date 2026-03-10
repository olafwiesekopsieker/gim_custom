table 80040 "gim Service Loc. KPI Buffer"
{
    TableType = Temporary;
    Caption = 'Service Location KPI Buffer';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            DataClassification = SystemMetadata;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = SystemMetadata;
        }
        field(4; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            DataClassification = SystemMetadata;
        }
        
        // Zeitraum 1
        field(10; "Invoices Count 1"; Integer)
        {
            Caption = 'No. of Invoices (Period 1)';
            DataClassification = SystemMetadata;
        }
        
        // Zeitraum 2
        field(11; "Invoices Count 2"; Integer)
        {
            Caption = 'No. of Invoices (Period 2)';
            DataClassification = SystemMetadata;
        }
        field(12; "Quotes Count"; Integer)
        {
            Caption = 'No. of Quotes (Period 2)';
            DataClassification = SystemMetadata;
        }
        field(13; "Orders Count"; Integer)
        {
            Caption = 'No. of Orders (Period 2)';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Ship-to Code")
        {
            Clustered = true;
        }
    }
}
