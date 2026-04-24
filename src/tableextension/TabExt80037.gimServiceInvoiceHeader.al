tableextension 80037 "gimServiceInvoiceHeader2" extends "Service Invoice Header"
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
        field(50003; "gimQty Service Items"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Service invoice Line" where("Document No." = field("No."),
                                                            "Service Item No." = filter('<>''''')));
            Caption = 'Qty Service Items';
            Description = '#AT';
        }
    }
}
