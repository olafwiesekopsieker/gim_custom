table 80002 "gimEtagisSnapshot"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Guid) { DataClassification = SystemMetadata; }

        field(10; "Table ID"; Integer) { }
        field(20; "ProdOrderNo"; Code[20]) { }
        field(30; "LineNo"; Integer) { }

        field(40; "StartOrig"; DateTime) { }
        field(50; "EndOrig"; DateTime) { }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
        key(UniqueLine; "Table ID", "ProdOrderNo", "LineNo") { }
    }
}