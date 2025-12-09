tableextension 80002 CertificateOfSupplyExt extends "Certificate of Supply"
{
    fields
    {
        // -------------------------------------------------
        // Systemfelder - Referenzen auf Belege
        // -------------------------------------------------
        field(80000; "gimAuftragsnummer"; Code[20])
        {
            Caption = 'Auftragsnummer';
            DataClassification = CustomerContent;

            TableRelation =
                if ("Document Type" = filter("Sales Shipment")) "Sales Header"."No." where("Document Type" = const(Order))
            else
            if ("Document Type" = filter("Service Shipment")) "Service Header"."No." where("Document Type" = const(Order));

            TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateDerivedFields();
            end;
        }

        field(80001; "Geb. Rechnungsnr."; Code[20])
        {
            Caption = 'Geb. Verkaufs-/Service-Rechnung';
            DataClassification = CustomerContent;

            TableRelation =
                if ("Document Type" = filter("Sales Shipment")) "Sales Invoice Header"."No."
            else
            if ("Document Type" = filter("Service Shipment")) "Service Invoice Header"."No.";

            trigger OnValidate()
            begin
                UpdateDerivedFields();
            end;
        }

        //-----------------------------------------------------------------
        // Versand / Zusteller
        //-----------------------------------------------------------------
        field(80002; FCA; Date)
        {
            Caption = 'FCA';
            DataClassification = CustomerContent;
        }

        field(80003; "FCA Versand beauftr. d. DÜSI"; Code[20])
        {
            Caption = 'FCA Versand beauftragt durch DÜSI';
            TableRelation = "Shipping Agent".Code; // Dropdown <Liste Zusteller>
            DataClassification = CustomerContent;
            ValidateTableRelation = false;
        }

        field(80004; "Versand durch DÜSI"; Code[20])
        {
            Caption = 'Versand durch DÜSI';
            DataClassification = CustomerContent;
            Editable = false; // wird automatisch gefüllt
        }

        //-----------------------------------------------------------------
        // Versand-/Zollstatus (Datum)
        //-----------------------------------------------------------------
        field(80010; "Zoll erstellt"; Date) { Caption = 'Zoll erstellt'; DataClassification = CustomerContent; }
        field(80011; POD; Date) { Caption = 'POD'; DataClassification = CustomerContent; }
        field(80012; "POD nachgefragt"; Date) { Caption = 'POD nachgefragt'; DataClassification = CustomerContent; }
        field(80013; "Ausgangsvermerk (AGV)"; Date) { Caption = 'Ausgangsvermerk (AGV)'; DataClassification = CustomerContent; }
        field(80014; "Ausgangsvermerk nachgefragt"; Date) { Caption = 'Ausgangsvermerk nachgefragt'; DataClassification = CustomerContent; }
        field(80015; Zollvermerk; Date) { Caption = 'Zollvermerk'; DataClassification = CustomerContent; }
        field(80016; Übergabebeleg; Date) { Caption = 'Übergabebeleg'; DataClassification = CustomerContent; }
        field(80017; UZ; Date) { Caption = 'UZ'; DataClassification = CustomerContent; }
        field(80018; ABD; Date) { Caption = 'ABD'; DataClassification = CustomerContent; }
        field(80019; "Packliste erstellt"; Date) { Caption = 'Packliste erstellt'; DataClassification = CustomerContent; }
        field(80020; Abholavis; Date) { Caption = 'Abholavis'; DataClassification = CustomerContent; }
        field(80021; Zollhandelsrechnung; Date) { Caption = 'Zollhandelsrechnung'; DataClassification = CustomerContent; }
        field(80022; "BL (Bill of Lading)"; Date) { Caption = 'BL (Bill of Lading)'; DataClassification = CustomerContent; }
        field(80023; VGM; Date) { Caption = 'VGM'; DataClassification = CustomerContent; }

        //-----------------------------------------------------------------
        // Verkäufer (werden automatisch aus Auftrag / Rechnung gefüllt)
        //-----------------------------------------------------------------
        field(80024; "Verkäufercode 1"; Code[20])
        {
            Caption = 'Verkäufercode 1';
            TableRelation = "Salesperson/Purchaser".Code;
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80025; "Verkäufercode 2"; Code[20])
        {
            Caption = 'Verkäufercode 2';
            TableRelation = "Salesperson/Purchaser".Code;
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(KeyByOrderNo; "gimAuftragsnummer") { }
        key(KeyByInvNo; "Geb. Rechnungsnr.") { }
    }

    //-----------------------------------------------------------------
    // Hilfsfunktion: Ableitung der Systemfelder aus Belegen
    //-----------------------------------------------------------------

    procedure UpdateDerivedFields()
    var
        FillMgt: Codeunit "gimCoSFillMgt";
    begin
        FillMgt.FillFromSources(Rec);
    end;

    procedure InitFromService(var ServiceShipmentHeader: Record "Service Shipment Header")
    begin
        // Nur anlegen, wenn noch kein CoS zu dieser Servicelieferung existiert
        if not Get("Document Type"::"Service Shipment", ServiceShipmentHeader."No.") then begin
            Init();
            "Document Type" := "Document Type"::"Service Shipment";
            "Document No." := ServiceShipmentHeader."No.";

            // Analoge Befüllung wie InitFromSales
            "Customer/Vendor Name" := ServiceShipmentHeader."Ship-to Name";
            "Shipment Method Code" := ServiceShipmentHeader."Shipment Method Code";

            // Je nach Tabellen-Design: Posting- oder Shipment-Datum
            "Shipment/Posting Date" := ServiceShipmentHeader."Posting Date";

            "Ship-to Country/Region Code" := ServiceShipmentHeader."Ship-to Country/Region Code";

            // Analog zu Sales: Bill-to als Kunde/Vendor
            "Customer/Vendor No." := ServiceShipmentHeader."Bill-to Customer No.";

            //OnAfterInitFromService(Rec, ServiceShipmentHeader);
            Insert(true);
        end;
    end;

}
