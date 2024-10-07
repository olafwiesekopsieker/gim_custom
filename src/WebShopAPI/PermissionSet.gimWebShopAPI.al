/// <summary>
/// Unknown gimWebShopAPI (ID 50013).
/// </summary>
permissionset 80001 gim2WebShopAPI
{
    Assignable = true;
    Caption = 'gimWebShopAPI', MaxLength = 30;
    Permissions =
        tabledata "WebshopStammdaten- DS" = R,
        tabledata "Webshop-DS" = R,
        tabledata "Item" = R,
        tabledata "Item Attribute" = R,
        tabledata "Item Attribute Value" = R,
        tabledata "Item Attribute Value Mapping" = R,
        tabledata "contact" = R,
        tabledata "sales header" = R,
        tabledata "sales line" = R,
        tabledata "sales header archive" = R,
        tabledata "Sales line archive" = R,
        tabledata "Sales Invoice header" = R,
        tabledata "Sales invoice line" = R,
        tabledata "Extended Text Header" = R,
        tabledata "Extended Text Line" = R,
        tabledata "Contact Mailing Group" = R,
        tabledata "Item Translation" = R,
        tabledata "Item Attribute Translation" = R,
        tabledata "Item Attr. Value Translation" = R,

        codeunit gim2DownloadImageToItem = X,


        page "WebshopStammdaten-DS" = X,
        page gimArtikelBild = X,
        page gim2ExtendedTextLine = X,
        page gim2ItemAttributeValueList = X,
        page gim2ItemAPI = X,
        page gim2ContactAPI = X,
        page "Webshop-DS" = X,
        page gim2WebshopStammdatenAPI = X,
        page gim2WebshopAPI = X,
        page gim2SalesHeaderAPI = X,
        page gim2SalesHeaderArchive = X,
        page gim2SalesInvoiceHeader = X,
        Page gim2ContactMailGroupAPI = X,
        query "gim2Item Attr. Value Mapping" = X,
        page gimItemAttrTransl = X,
        page gimItemAttrValueTransl = X;

}