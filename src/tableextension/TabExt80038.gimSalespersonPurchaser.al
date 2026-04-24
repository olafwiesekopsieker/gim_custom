tableextension 80009 "gimSalespersonPurchaser" extends "Salesperson/Purchaser"
{
    fields
    {
        field(80001; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }
}