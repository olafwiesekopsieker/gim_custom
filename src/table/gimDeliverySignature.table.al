table 80000 "gimDeliverySignature"
{
    Caption = 'Delivery Signature';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Header SystemId"; Guid)
        {
            Caption = 'Sales Header SystemId';
        }
        field(2; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; "Signature Date"; Date)
        {
            Caption = 'Signature Date';
        }
        field(11; "Forwarder"; Text[100])
        {
            Caption = 'Spedition';
        }
        field(12; "Truck License Plate"; Code[20])
        {
            Caption = 'LKW-Kennzeichen';
        }
        field(20; "Signature Image"; Media)
        {
            Caption = 'Signature';
        }
    }

    keys
    {
        key(PK; "Sales Header SystemId")
        {
            Clustered = true;
        }
        key(ByDoc; "Document Type", "Document No.") { }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Document No.", "Signature Date", Forwarder, "Truck License Plate", "Signature Image")
        {

        }
    }
}
