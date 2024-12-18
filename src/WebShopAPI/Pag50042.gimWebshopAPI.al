page 80010 gim2WebshopAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimWebshopAPI';
    DelayedInsert = true;
    EntityName = 'gimWebshop';
    EntitySetName = 'gimWebshops';
    PageType = API;
    SourceTable = "Webshop-DS";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
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
                field(Linie; rec.Linie)
                {
                    caption = 'Modell';
                }
                field(einsatzProgrammabschnitt; Rec."Einsatz/Programmabschnitt")
                {
                    Caption = 'Einsatz/Programmabschnitt';
                }

                field(produktgruppe; Rec.Produktgruppe)
                {
                    Caption = 'Produktgruppe';
                }
                field(SystemModifiedAt; rec.SystemModifiedAt)
                {
                    caption = 'SystemModifiedAt';
                }
            }
        }
    }
}
