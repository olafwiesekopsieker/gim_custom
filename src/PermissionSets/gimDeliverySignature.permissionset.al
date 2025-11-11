permissionset 80002 "gimDELIV_SIGNATURE"
{
    Assignable = true;
    Caption = 'Capture & store delivery signatures';

    Permissions =
        // Deine Daten
        tabledata "gimDeliverySignature" = RIMD,

        // Benötigte Pages
        page "gimDeliverySignatureCapture" = X,
        page "gimDeliverySignatureList" = X,

        // Lesen von Verkaufsaufträgen (für Auswahl/Lookup)
        tabledata "Sales Header" = R,

        // Media-Infrastruktur (für ImportStream/ExportStream auf Media-Felder)
        tabledata "Tenant Media" = RIMD,
        tabledata "Tenant Media Set" = RIMD,

        // Helper-Codeunits (werden in Page-Triggern genutzt)
        codeunit "Base64 Convert" = X,
        codeunit "Temp Blob" = X;
}
