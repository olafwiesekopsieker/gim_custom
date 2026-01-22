// codeunit 80003 "gim Upgrade SalesLine WhseSubt"
// {
//     Subtype = Upgrade;

//     trigger OnUpgradePerCompany()
//     var
//         SalesLine: Record "Sales Line";
//         Cnt: Integer;
//     begin
//         // Nur Zeilen anfassen, wo unser Feld leer/falsch ist
//         SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
//         SalesLine.SetRange("gim Whse Source Subtype", 0); // wenn 0 bei dir als "nicht gefüllt" gilt
//         SalesLine.SetLoadFields("Document Type", "gim Whse Source Subtype");

//         if SalesLine.FindSet() then begin
//             repeat
//                 SalesLine."gim Whse Source Subtype" := SalesLine."Document Type".AsInteger();
//                 SalesLine.Modify(false);

//                 Cnt += 1;
//             // optional: bei sehr vielen Datensätzen gelegentlich committen
//             //if (Cnt mod 5000) = 0 then
//             //Commit();
//             until SalesLine.Next() = 0;
//         end;
//     end;
// }
