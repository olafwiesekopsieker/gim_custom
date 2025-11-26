// codeunit 80007 "gimCoSInstall"
// {
//     Subtype = Upgrade;

//     trigger OnUpgradePerCompany()
//     //OnInstallAppPerCompany()
//     begin
//         BackfillInvoiceNoFromShipment();
//     end;

//     local procedure BackfillInvoiceNoFromShipment()
//     var
//         CoS: Record "Certificate of Supply";
//         SalesInvLine: Record "Sales Invoice Line";
//         ServInvLine: Record "Service Invoice Line";
//     begin
//         if CoS.FindSet() then
//             repeat
//                 // if CoS."Geb. Rechnungsnr." <> '' then
//                 //     continue;

//                 case CoS."Document Type" of
//                     CoS."Document Type"::"Sales Shipment":
//                         begin
//                             SalesInvLine.Reset();
//                             SalesInvLine.SetRange("Order No.", CoS."gimAuftragsnummer");
//                             SalesInvLine.SetCurrentKey("Posting Date", "Document No.", "Line No.");
//                             SalesInvLine.SetAscending("Posting Date", false); // jüngste Rechnung zuerst
//                             if SalesInvLine.FindFirst() then begin
//                                 CoS.Validate("Geb. Rechnungsnr.", SalesInvLine."Document No.");
//                                 CoS.Modify(true); // triggert UpdateDerivedFields()
//                             end else begin
//                                 CoS.Validate("Geb. Rechnungsnr.", '');
//                                 CoS.Modify(true); // triggert UpdateDerivedFields()
//                             end;
//                         end;

//                     CoS."Document Type"::"Service Shipment":
//                         begin
//                             ServInvLine.Reset();
//                             ServInvLine.SetRange("Order No.", CoS."gimAuftragsnummer");
//                             ServInvLine.SetCurrentKey("Posting Date", "Document No.", "Line No.");
//                             ServInvLine.SetAscending("Posting Date", false);
//                             if ServInvLine.FindFirst() then begin
//                                 CoS.Validate("Geb. Rechnungsnr.", ServInvLine."Document No.");
//                                 CoS.Modify(true);
//                             end else begin
//                                 CoS.Validate("Geb. Rechnungsnr.", '');
//                                 CoS.Modify(true); // triggert UpdateDerivedFields()
//                             end;
//                         end;
//                 end;
//             until CoS.Next() = 0;
//     end;
// }