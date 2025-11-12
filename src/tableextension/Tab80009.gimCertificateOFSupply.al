tableextension 80002 CertificateOfSupplyExt extends "Certificate of Supply"
{
    fields
    {
        field(80000; FCA; Boolean)
        {
            Caption = 'FCA';
            DataClassification = SystemMetadata;
        }
        field(80001; "FCA Versand beauftragt durch DÜSI"; Code[10])
        {
            Caption = 'FCA Versand beauftragt durch DÜSI';
            DataClassification = SystemMetadata;
            TableRelation = "Shipping Agent";
        }
        field(80002; "Versand durch DÜSI"; Boolean)
        {
            Caption = 'Versand durch DÜSI';
            DataClassification = SystemMetadata;
        }
        field(80003; "Zoll erstellt"; Boolean)
        {
            Caption = 'Zoll erstellt';
            DataClassification = SystemMetadata;
        }
        field(80004; POD; Boolean)
        {
            Caption = 'POD';
            DataClassification = SystemMetadata;
        }
        field(80005; "POD nachgefragt"; Boolean)
        {
            Caption = 'POD nachgefragt';
            DataClassification = SystemMetadata;
        }
        field(80006; "Ausgangsvermerk (AGV)"; Text[200])
        {
            Caption = 'Ausgangsvermerk (AGV)';
            DataClassification = SystemMetadata;
        }
        field(80007; "Ausgangsvermerk nachgefragt"; Boolean)
        {
            Caption = 'Ausgangsvermerk nachgefragt';
            DataClassification = SystemMetadata;
        }
        field(80008; Zollvermerk; Text[200])
        {
            Caption = 'Zollvermerk';
            DataClassification = SystemMetadata;
        }
        field(80009; Übergabebeleg; Boolean)
        {
            Caption = 'Übergabebeleg';
            DataClassification = SystemMetadata;
        }
        field(80010; UZ; Boolean)
        {
            Caption = 'UZ';
            DataClassification = SystemMetadata;
        }
        field(80011; ABD; Boolean)
        {
            Caption = 'ABD';
            DataClassification = SystemMetadata;
        }
        field(80012; "Packliste erstellt"; Boolean)
        {
            Caption = 'Packliste erstellt';
            DataClassification = SystemMetadata;
        }
        field(80013; Abholavis; Boolean)
        {
            Caption = 'Abholavis';
            DataClassification = SystemMetadata;
        }
        field(80014; Zollhandelsrechnung; Boolean)
        {
            Caption = 'Zollhandelsrechnung';
            DataClassification = SystemMetadata;
        }
        field(80015; "BL (Bill of Lading)"; Boolean)
        {
            Caption = 'BL (Bill of Lading)';
            DataClassification = SystemMetadata;
        }
        field(80016; VGM; Boolean)
        {
            Caption = 'VGM';
            DataClassification = SystemMetadata;
        }
    }
}