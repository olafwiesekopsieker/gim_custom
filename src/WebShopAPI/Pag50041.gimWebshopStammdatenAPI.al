/// <summary>
/// Page gimWebshopStammdatenAPI (ID 50041).
/// </summary>
page 80009 gim2WebshopStammdatenAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimWebshopStammdatenAPI';
    DelayedInsert = true;
    EntityName = 'gimWebshopStammdata';
    EntitySetName = 'gimWebshopStammdaten';
    PageType = API;
    SourceTable = "WebshopStammdaten- DS";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(descriptionEN; Rec."Description(EN)")
                {
                    Caption = 'Description(EN)';
                }
                field(descriptionFR; Rec."Description(FR)")
                {
                    Caption = 'Description(FR)';
                }
                field(ebene; Rec.Ebene)
                {
                    Caption = 'Ebene';
                }
                field(produktkategorie; Rec.Produktkategorie)
                {
                    Caption = 'Produktkategorie';
                }
                field(zubehoer; Rec.Zubehoer)
                {
                    Caption = 'Zubehoer';
                }
                field(einsatzProduktabschnitt; Rec."Einsatz/Produktabschnitt")
                {
                    Caption = 'Einsatz/Produktabschnitt';
                }
                field(produktgruppe; Rec.Produktgruppe)
                {
                    Caption = 'Produktgruppe';
                }
                field(modellgroesse; Rec.Modellgroesse)
                {
                    Caption = 'Modellgroesse';
                }
                field(linie; Rec.Linie)
                {
                    Caption = 'Modell';
                }
                field("Modelltyp"; rec."Bezeichnung-Zusatz")
                {
                    caption = 'Modelltyp';
                }
                field(SystemModifiedAt; rec.SystemModifiedAt)
                {
                    caption = 'SystemModifiedAt';
                }
            }
        }
    }
}
