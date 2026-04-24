tableextension 80034 "gimServiceHeader2" extends "Service Header"
{
    fields
    {
        field(80003; "LEAD Nummer"; Text[50])
        {
            Caption = 'LEAD Nummer';
            DataClassification = ToBeClassified;
        }
        field(80005; "Technician User ID"; Code[50])
        {
            Caption = 'Technician User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }
}
