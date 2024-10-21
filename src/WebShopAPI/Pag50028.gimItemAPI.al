/// <summary>
/// Page gimItemAPI (ID 50028).
/// </summary>
page 80005 gim2ItemAPI
{
    APIGroup = 'gimWebshop';
    APIPublisher = 'gim';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'gimItemAPI';
    DelayedInsert = true;
    EntityName = 'gim2Item';
    EntitySetName = 'gim2ItemSet';
    PageType = API;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(ccsDMDescription3; Rec."CCS DM Description 3")
                {
                    Caption = 'Description 3';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit of Measure';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(gtin; Rec.GTIN)
                {
                    Caption = 'GTIN';
                }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                field(ItemCategoryId; rec."Item Category Id")
                {
                    Caption = 'Item Category ID';
                }
                field(serviceItemGroup; Rec."Service Item Group")
                {
                    Caption = 'Service Item Group';
                }

                field(freightType; Rec."Freight Type")
                {
                    Caption = 'Freight Type';
                }
                field(abmessung1; Rec.Abmessung1)
                {
                    Caption = 'Dimension1';
                }
                field(abmessung2; Rec.Abmessung2)
                {
                    Caption = 'Dimension2';
                }
                field(abmessung3; Rec.Abmessung3)
                {
                    Caption = 'Dimension3';
                }
                field(innenabmessung1; Rec.Innenabmessung1)
                {
                    Caption = 'Innenabmessung(B)';
                }
                field(innenabmessung2; Rec.Innenabmessung2)
                {
                    Caption = 'Innenabmessung(T)';
                }
                field(innenabmessung3; Rec.Innenabmessung3)
                {
                    Caption = 'Innenabmessung(H)';
                }
                field(durchmesser1; Rec.Durchmesser1)
                {
                    Caption = 'Durchmesser(Innen)';
                }
                field(durchmesser2; Rec.Durchmesser2)
                {
                    Caption = 'Durchmesser(Aussen)';
                }
                field(kategorie; Rec.Kategorie)
                {
                    Caption = 'Kategorie';
                }
                field(katalog; Rec.Katalog)
                {
                    Caption = 'Katalog';
                }
                field(preisrelevant; Rec.Preisrelevant)
                {
                    Caption = 'Preisrelevant';
                }
                field(maxPackSizeLeft; Rec."Max Pack Size left")
                {
                    Caption = 'Max Pack Size left';
                }
                field(maxPackSizeRight; Rec."Max Pack Size right")
                {
                    Caption = 'Max Pack Size right';
                }
                field(maxTragfStellfLinks; Rec."Max Tragf. Stellf. links")
                {
                    Caption = '<Max Tragfähigkeit Stellfläche, links>';
                }
                field(maxTragfStellfRechts; Rec."Max Tragf. Stellf. rechts")
                {
                    Caption = '<Max Tragfähigkeit Stellfläche, rechts>';
                }
                field(maxLoadCapacity; Rec."Max Load Capacity")
                {
                    Caption = 'Max Load Capacity';
                }
                field(genProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    Caption = 'Gen. Prod. Posting Group';
                }
                field(GenProdPostingGroupId; rec."Gen. Prod. Posting Group Id")
                {
                    caption = 'Gen. Prod. Posting Group Id';
                }
                field(inventoryPostingGroup; Rec."Inventory Posting Group")
                {
                    Caption = 'Inventory Posting Group';
                }
                field(inventoryPostingGroupID; Rec."Inventory Posting Group ID")
                {
                    Caption = 'Inventory Posting Group ID';
                }
                field(tariffNo; Rec."Tariff No.")
                {
                    Caption = 'Tariff No.';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorItemNo; Rec."Vendor Item No.")
                {
                    Caption = 'Vendor Item No.';
                }
                field(Partnerportal; Rec.Partnerportal)
                {
                    Caption = 'Partnerportal';
                }


                // part(gimExtendedTextLine; gimExtendedTextLine)
                // {
                //     ApplicationArea = all;
                //     Caption = 'textLines', Locked = True;
                //     EntityName = 'gimItemTextLine';
                //     EntitySetName = 'gimItemTextLines';
                //     SubPageLink = "Table Name" = Filter('Item'), "No." = field("No.");
                // }
                // part(ItemAttributeValueList; "Item Attribute Value List")
                // {
                //     ApplicationArea = All;
                //     EntityName = 'gimItemAttribute';
                //     EntitySetName = 'gimItemAttributes';
                // }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        // CurrPage.ItemAttributeValueList.PAGE.LoadAttributes(rec."No.");
    end;
}
