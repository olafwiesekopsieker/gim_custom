report 80000 "gimCheck List for Archived"
{
    Caption = 'Check List';
    DefaultRenderingLayout = "./src/report/CCOCheckList2.rdl";

    dataset
    {
        dataitem("Service Item Line"; "MUL SNAD Arch Serv. Item Line")
        {
            RequestFilterFields = "Document No.";
            DataItemTableView = sorting("Service Item No.", "Document Type", "Document No.", "Line No.");
            column(DocNo; "Document No.") { }
            column(ServiceItemNo; "Service Item No.") { }
            column(Pruefdatum; Format("Service Item Line"."Finishing Date")) { }
            column(ServiceItemCaption; GetServiceItemCaption("Service Item Line")) { }
            column(ShiptoName_ServiceHeader; ServiceHeader."Ship-to Name") { }
            column(ShiptoAdress_ServiceHeader; ServiceHeader."Ship-to Address 2") { }
            column(ShiptoCity_ServiceHeader; ServiceHeader."Ship-to City") { }
            column(ShiptoContact_ServiceHeader; ServiceHeader."Ship-to Contact") { }
            column(ShiptoPhone_ServiceHeader; ServiceHeader."Ship-to Phone") { }
            column(YourRef_ServiceHeader; ServiceHeader."Your Reference") { }
            column(PhoneNo_ServiceHeader; ServiceHeader."Phone No.") { }
            column(ExternalDocNo_ServiceHeader; ServiceHeader."External Document No.") { }
            column(PoDate_ServiceHeader; Format(ServiceHeader."PO Date", 0, '<Standard Format,1>')) { }
            column(ServiceHeader_ShipToContact; ServiceHeader."Ship-to Contact") { }
            column(ServiceItemNo_ServiceItemLine; "Service Item Line"."Service Item No.") { }
            column(SignatureName_ServiceItemLine; ServiceHeader.signatureName) { } // TODO: Überprüfen
            //column(SignatureName_ServiceItemLine; blank) { } // TODO: Überprüfen

            column(Gebaeude_ServiceItem; ServiceItem.Gebäude) { }
            column(KeyNo_ServiceItem; ServiceItem."Key-No.") { }
            column(Ebene_ServiceItem; ServiceItem.Ebene) { }
            column(InventarNo_ServiceItem; ServiceItem."Customer Service ID") { }
            column(Standort_ServiceItem; ServiceItem."Location of Service Item") { }
            column(Raum_ServiceItem; ServiceItem.Raum) { }
            column(SerialNo_ServiceItem; ServiceItem."Serial No.") { }
            column(Model_ServiceItem; ServiceItem.Model) { }
            column(Hersteller_ServiceItem; ServiceItem.Hersteller) { }
            column(Servicebarcode_ServiceItem; ServiceItem.Servicebarcode) { }
            column(Salesperson_Name; Salesperson.Name) { }
            column(CustomerServiceID__ServiceItem; ServiceItem."Customer Service ID") { }
            column(ReactivateText; ReactivateText) { }
            dataitem("MUL SNAD Answer Group"; "MUL SNAD Answer Group Arch.")
            {
                DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                DataItemLinkReference = "Service Item Line";
                PrintOnlyIfDetail = true;
                dataitem("MUL SNAD Answer"; "MUL SNAD Answer Arch.")
                {
                    DataItemLink = "Answer Group No." = field("Answer Group No.");
                    DataItemLinkReference = "MUL SNAD Answer Group";
                    DataItemTableView = sorting(Position);
                    column(Position; "MUL SNAD Answer".Position) { }

                    column(Answer_SA; "MUL SNAD Answer".Answer) { }
                    column(Data_Type; format("MUL SNAD Answer"."Data Type")) { }
                    column(Description_SQ; DescriptionSQ) { }

                    column(NotificationText; NotificationText) { }
                    column(Testbadge; Testbadge) { }
                    column(Signature_ServiceItemLine; "Service Item Line"."Signature") { }

                    trigger OnAfterGetRecord();
                    begin
                        if not GetDescriptionAndTexts() then
                            CurrReport.Skip();

                        if Answer = 'BAUART' then
                            Answer := 'FEHLT BAUARTBEDINGT';

                        Clear("Service Item Line"."Signature");
                        Testbadge := (ServotionQuestion.Description = 'Prüfplakette erteilt');
                        if Testbadge then
                            if Answer = '' then
                                Answer := 'NEIN'
                            else
                                "Service Item Line".CalcFields("Signature");

                        if not ("data type" in ["Data Type"::Caption]) then begin
                            if Answer = '' then
                                CurrReport.Skip();
                        end else
                            if not CaptionEntryHasValues() then
                                CurrReport.Skip();
                    end;
                }
            }
            trigger OnAfterGetRecord();
            begin
                if not UseServiceItemGroup("Service Item Line"."Service Item Group Code") then
                    CurrReport.Skip();

                if (ServiceHeader."Document Type" <> "Service Item Line"."Document Type") and (ServiceHeader."No." <> "Service Item Line"."Document No.") then
                    if not ServiceHeader.Get("Service Item Line"."Document Type", "Service Item Line"."Document No.") then
                        ServiceHeader.Init();
                if not ServiceItem.Get("Service Item Line"."Service Item No.") then
                    ServiceItem.Init();
                if not Salesperson.Get(ServiceHeader."Salesperson Code") then
                    Salesperson.Init();

                "MUL SNAD Answer Group".SetRange("MUL SNAD Answer Group"."Source ID", "Service Item Line"."Document No.");
                "MUL SNAD Answer Group".SetRange("MUL SNAD Answer Group"."Source Ref. No.", "Service Item Line"."Line No.");

                "MUL SNAD Answer".SetRange("MUL SNAD Answer"."Answer Group No.", "MUL SNAD Answer Group"."Answer Group No.");
                "MUL SNAD Answer Group".CalcFields("MUL SNAD Answer Group"."Answers (Filled)");
            end;
        }
        dataitem(OneTimeDocument; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(Picture_CompanyInfo; CompanyInfo.Picture) { }
            column(Picture2_CompanyInfo; CompanyInfo."Picture 2") { }
        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Inbetriebnahme; InbetriebnahmeBool)
                    {
                        ApplicationArea = All;
                        Caption = 'Wiederin-/Inbetriebnahme';
                    }
                }
            }
        }
    }

    rendering
    {
        layout("./src/report/CCOCheckList2.rdl")
        {
            Type = RDLC;
            LayoutFile = './src/report/CCOCheckList2.rdl';
        }
    }

    local procedure GetServiceItemCaption(ServiceItemLine: Record "MUL SNAD Arch Serv. Item Line"): Text
    begin
        case ServiceItemLine."Service Item Group Code" of
            'FILTER':
                exit('Filterwartung nach Anforderung aus: DIN 12927 / DIN 6022 / DIN 1946-7');
            'SCHRANK':
                exit('Prüfzertifikat gemäß BetrSichV, TRGS 526, TRGS 510 und ArbStättV §4');
            'LABABZ':
                exit('Prüfung von Labor-Abzügen gem. Richlinien für Laboratorien, Ziffer 1.5');
        end;
    end;

    local procedure GetDescriptionAndTexts(): Boolean
    begin
        Clear(DescriptionSQ);
        Clear(NotificationText);
        if not ServotionQuestion.Get("MUL SNAD Answer"."Question No.") then
            exit;

        if "MUL SNAD Answer"."Data Type" = "MUL SNAD Answer"."data type"::Caption then
            DescriptionSQ := '<b><u>' + ServotionQuestion.Description + '</b></u>'
        else
            DescriptionSQ := ServotionQuestion.Description;

        if (ServotionQuestion.Description = 'Hinweis TRGS-510') then begin
            Clear(DescriptionSQ);
            if ("MUL SNAD Answer".Answer = 'JA') then
                NotificationText := '<b>Hinweis: Sie haben einen Sicherheitsschrank nach DIN 12925-1/-2 mit Feuerwiderstandsfähigkeit 20 Minuten im Einsatz. Mit Inkrafttreten der geänderten TRGS 510 wurden die gesetzlichen Rahmenbedingungen für den Betrieb dieser Schränke weiter konkretisiert. Gerne unterstützen wir Sie bei der Umsetzung, den Stand der Technik zu erlangen – sprechen Sie uns bitte an!</b>'
            else
                exit;
        end;
        exit(true);
    end;

    local procedure CaptionEntryHasValues(): Boolean
    var
        AnswerCompare: Record "MUL SNAD Answer Arch.";
    begin
        AnswerCompare := "MUL SNAD Answer";
        AnswerCompare.CopyFilters("MUL SNAD Answer");
        while (AnswerCompare.Next() <> 0) do begin
            if AnswerCompare.Answer <> '' then
                exit(true);
            if (AnswerCompare."Data Type" = AnswerCompare."Data Type"::Caption) then
                exit(false);
        end;
        exit(false);
    end;

    local procedure UseServiceItemGroup(ServiceItemGroupCode: Code[10]): Boolean
    var
        ServiceItemGroup: Record "Service Item Group";
    begin
        if ServiceItemGroupCode = '' then
            exit;
        ServiceItemGroup.Reset();
        ServiceItemGroup.SetRange(Code, ServiceItemGroupCode);
        ServiceItemGroup.SetRange("CCO Print in Service Checklist", true);
        exit(not ServiceItemGroup.IsEmpty());
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.CalcFields(Picture, "Picture 2");
        if InbetriebnahmeBool then
            ReactivateText := 'Die Prüfung erfolgte gem. den o. g Prüfkriterien und Aufgrund von Inbetriebnahme / Wiederinbetriebnahme nach prüfpflichtigen Änderungen gem. BetrSichV §15.';
        blank := '';
    end;

    var
        ServotionQuestion: Record "MUL SNAD Question";
        Salesperson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        ServiceItem: Record "Service Item";
        ServiceHeader: Record "MUL SNAD Arch Serv. Header";
        DescriptionSQ, NotificationText, ReactivateText : Text;
        Testbadge, InbetriebnahmeBool : Boolean;
        blank: text;
}