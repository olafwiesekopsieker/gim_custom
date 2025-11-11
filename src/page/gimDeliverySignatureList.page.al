page 80024 "gimDeliverySignatureList"
{
    PageType = List;
    SourceTable = "gimDeliverySignature";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Delivery Signatures';

    layout
    {
        area(content)
        {
            repeater(Grp)
            {
                field("Document Type"; rec."Document Type") { ApplicationArea = All; }
                field("Document No."; rec."Document No.") { ApplicationArea = All; }
                field("Signature Date"; rec."Signature Date") { ApplicationArea = All; }
                field("Forwarder"; rec."Forwarder") { ApplicationArea = All; }
                field("Truck License Plate"; rec."Truck License Plate") { ApplicationArea = All; }
                field("Signature Image"; rec."Signature Image")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = true;     // oder false, Geschmackssache
                    Width = 18;            // wichtig: genug Platz für das Bild
                }
            }
        }
        area(FactBoxes)
        {
            part(SignatureViewer; "gimDeliverySignatureFactBox")
            {
                ApplicationArea = All;
                // Verknüpft den gleichen DS-Datensatz in der FactBox
                SubPageLink = "Sales Header SystemId" = field("Sales Header SystemId");
            }
        }
    }



}