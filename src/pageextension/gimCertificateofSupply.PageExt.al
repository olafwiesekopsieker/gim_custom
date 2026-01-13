pageextension 80028 gimCertificateOfSupplyList extends "Certificates of Supply"
{
    layout
    {
        addFirst(Group)
        {
            field("gimAuftragsnummer"; Rec."gimAuftragsnummer") { ApplicationArea = All; }
        }
        addafter("No.")
        {
            field("Geb. Verkaufsrechnung"; Rec."Geb. Rechnungsnr.") { ApplicationArea = All; }
        }
        addafter("Shipment Country")
        {

            field(FCA; Rec.FCA) { ApplicationArea = All; }
            field("FCA Versand beauftragt durch DÜSI"; Rec."FCA Versand beauftr. d. DÜSI") { ApplicationArea = All; }
            field("Versand durch DÜSI"; Rec."Versand durch DÜSI") { ApplicationArea = All; }
            field("Zoll erstellt"; Rec."Zoll erstellt") { ApplicationArea = All; }
            field(POD; Rec.POD) { ApplicationArea = All; }
            field("POD nachgefragt"; Rec."POD nachgefragt") { ApplicationArea = All; }
            field("Ausgangsvermerk (AGV)"; Rec."Ausgangsvermerk (AGV)") { ApplicationArea = All; }
            field("Ausgangsvermerk nachgefragt"; Rec."Ausgangsvermerk nachgefragt") { ApplicationArea = All; }
            field(Zollvermerk; Rec.Zollvermerk) { ApplicationArea = All; }
            field(Übergabebeleg; Rec.Übergabebeleg) { ApplicationArea = All; }
            field(UZ; Rec.UZ) { ApplicationArea = All; }
            field(ABD; Rec.ABD) { ApplicationArea = All; }
            field("Packliste erstellt"; Rec."Packliste erstellt") { ApplicationArea = All; }
            field(Abholavis; Rec.Abholavis) { ApplicationArea = All; }
            field(Zollhandelsrechnung; Rec.Zollhandelsrechnung) { ApplicationArea = All; }
            field("BL (Bill of Lading)"; Rec."BL (Bill of Lading)") { ApplicationArea = All; }
            field(VGM; Rec.VGM) { ApplicationArea = All; }
        }
        Addafter("Vehicle Registration No.")
        {
            field("Verkäufercode 1"; Rec."Verkäufercode 1") { ApplicationArea = All; }
            field("Verkäufercode 2"; Rec."Verkäufercode 2") { ApplicationArea = All; }

        }


    }
    actions
    {
        addlast(processing)
        {
            action(ProcessRechnungen)
            {
                ApplicationArea = All;
                Caption = 'Gelangenbestätigung Daten aktualisieren';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;

                trigger OnAction()
                var
                    COSFill: Codeunit gimCoSFillMgt;
                begin



                    //cosfill.RebuildCoSForPostingDateRange(20240901D, 20251231D);
                    //CosFill.ResetSuspiciousInvoiceNos();
                    CosFill.BackfillOrderNo();
                    CosFill.BackfillInvoiceNo();

                    message('job erledigt');



                end;
            }
        }
    }
}