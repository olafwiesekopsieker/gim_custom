page 80023 "gimDeliverySignatureCapture"
{
    PageType = StandardDialog;
    Caption = 'Delivery Signature Capture';
    ApplicationArea = All;
    UsageCategory = None; // nur modal aufrufen
    Editable = true;

    layout
    {
        area(content)
        {
            group(Selection)
            {
                Caption = 'Ausgewählte Aufträge/Selected Orders';
                field(OrdersText; OrdersText)
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Kommaseparierte Liste der ausgewählten Aufträge.';
                }
            }
            group(General)
            {
                Caption = 'Details';
                field(SignatureDate; SignatureDate) { Caption = 'Datum/Date'; ApplicationArea = All; }
                field(Forwarder; Forwarder) { Caption = 'Spedition/Forwarder'; ApplicationArea = All; }
                field(TruckPlate; TruckPlate) { Caption = 'LKW-Kennzeichen/Truckplate'; ApplicationArea = All; }
            }
            group(Sign)
            {
                Caption = 'Unterschrift/Sign';
                usercontrol(Signature; "gimSignaturePad") // <- 
                {
                    ApplicationArea = All;

                    trigger ControlReady()
                    begin
                        CurrPage.signature.ShowToolbar(true);    // Toolbar sichtbar
                        CurrPage.Signature.SetReadOnly(false);   // Zeichnen erlaubt
                        SignatureDate := Workdate();
                    end;

                    trigger SignatureSubmit(Base64NoPrefix: Text)
                    begin
                        // Speichern für alle Ziele + Bild in Media
                        SaveAll(Base64NoPrefix);
                        // Optional: schließen nach Save
                        CurrPage.Close();
                    end;

                }
            }
        }

    }

    actions
    {
        area(processing)
        {
            action(Clear)
            {
                Caption = 'Leeren';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CurrPage.Signature.Clear();
                    SignatureBase64 := '';
                end;
            }

            action(SaveSignature) // optionaler Testknopf, kann weg
            {
                Caption = 'Unterschrift speichern';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CurrPage.Signature.GetSignature(); // leer
                end;
            }





        }
    }


    var
        OrdersText: Text;
        SignatureDate: Date;
        Forwarder: Text[100];
        TruckPlate: Code[20];
        SignatureBase64: Text;
        TargetSysIds: List of [Guid];  // Ziel-Aufträge, die gespeichert werden

        AwaitingSignature: Boolean; // wir warten auf JS-Rückruf
        ClosingRequested: Boolean;  // OK/Schließen wurde angefordert

    // --- Getter für den Aufrufer (List-Action) ---




    procedure SetOrdersText(Value: Text)
    begin
        OrdersText := Value;
    end;

    procedure GetSignatureBase64(): Text
    begin
        exit(SignatureBase64);
    end;

    procedure GetSignatureDate(): Date
    begin
        exit(SignatureDate);
    end;

    procedure GetForwarder(): Text
    begin
        exit(Forwarder);
    end;

    procedure GetTruckPlate(): Code[20]
    begin
        exit(TruckPlate);
    end;

    procedure SetTargetSysIds(Ids: List of [Guid])
    var
        i: Integer;
        g: Guid;
    begin

        for i := 1 to Ids.Count() do begin
            Ids.Get(i, g);
            TargetSysIds.Add(g);
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if closeaction = closeaction::OK then BEGIN
            CurrPage.Signature.GetSignature();
            exit(false);
        end;

    end;

    local procedure SaveAll(SignatureBase64: Text)
    begin
        // Speichert für alle Ziel-SystemIds inkl. Media (PNG-Beispiel)
        CreateOrUpdateDeliverySignatures(TargetSysIds, SignatureBase64, SignatureDate, Forwarder, TruckPlate);
    end;

    // ---------- Helfer: Upsert + Media-Import ----------
    local procedure CreateOrUpdateDeliverySignatures(var SysIds: List of [Guid]; B64: Text; SigDate: Date; Fwd: Text; Plate: Code[20]) ProcessedCount: Integer
    var
        i: Integer;
        Id: Guid;
        SalesHdr: Record "Sales Header";
        SigRec: Record "gimDeliverySignature";
        TempBlob: Codeunit "Temp Blob";
        Base64Conv: Codeunit "Base64 Convert";
        OutS: OutStream;
        InS: InStream;
        HasSig: Boolean;
        FileName: Text;
    begin
        ProcessedCount := 0;

        // Wir nehmen PNG als Standard (falls du JPEG nutzt: 'signature.jpg')
        HasSig := B64 <> '';
        if HasSig then begin
            TempBlob.CreateOutStream(OutS);
            Base64Conv.FromBase64(B64, OutS);   // Body ohne Prefix -> Binär
            // InStream pro Datensatz neu erzeugen (wird beim Import verbraucht)
            FileName := 'signature.png';        // steuert MIME-Type image/png
        end;

        for i := 1 to SysIds.Count() do begin
            SysIds.Get(i, Id);

            // Optional: Daten vom Sales Header holen (falls noch vorhanden)
            SalesHdr.Reset();
            SalesHdr.SetRange(SystemId, Id);
            SalesHdr.FindFirst();

            // Upsert per PK = SystemId
            if not SigRec.Get(Id) then begin
                SigRec.Init();
                SigRec."Sales Header SystemId" := Id;
                if SalesHdr."No." <> '' then begin
                    SigRec."Document Type" := SalesHdr."Document Type";
                    SigRec."Document No." := SalesHdr."No.";
                end;
                SigRec."Signature Date" := SigDate;
                SigRec."Forwarder" := Fwd;
                SigRec."Truck License Plate" := Plate;
                SigRec.Insert(true);
            end else begin
                if SalesHdr."No." <> '' then begin
                    SigRec."Document Type" := SalesHdr."Document Type";
                    SigRec."Document No." := SalesHdr."No.";
                end;
                SigRec."Signature Date" := SigDate;
                SigRec."Forwarder" := Fwd;
                SigRec."Truck License Plate" := Plate;
                SigRec.Modify(true);
            end;

            // Signatur importieren (falls vorhanden)
            if HasSig then begin
                TempBlob.CreateInStream(InS);
                SigRec."Signature Image".ImportStream(InS, FileName); // MIME-Type via Endung
                SigRec.Modify(true);
            end;

            ProcessedCount += 1;
        end;
    end;
}
