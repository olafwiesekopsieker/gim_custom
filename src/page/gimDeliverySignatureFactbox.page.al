page 80025 "gimDeliverySignatureFactBox"
{
    PageType = CardPart;
    SourceTable = "gimDeliverySignature";
    Caption = 'Lieferunterschrift';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Image)
            {
                Caption = 'Unterschrift';
                usercontrol(ViewPad; "gimSignaturePad")
                {
                    ApplicationArea = All;
                    //Editable = false; // Page-seitig schreibgeschützt
                    trigger ControlReady()
                    begin
                        IsPadReady := true;
                        CurrPage.ViewPad.SetReadOnly(true);
                        LoadSignatureFromRecord(); // erste Füllung
                    end;
                }
            }

        }

    }

    actions
    {

    }
    var
        IsPadReady: Boolean;

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        if isPADReady then LoadSignatureFromRecord(); // bei Datensatzwechsel neu laden
    end;

    local procedure LoadSignatureFromRecord()
    var
        TempBlob: Codeunit "Temp Blob";
        Base64Conv: Codeunit "Base64 Convert";
        OutS: OutStream;
        InS: InStream;
        B64: Text;
    begin
        if Rec."Signature Image".HasValue then begin
            TempBlob.CreateOutStream(OutS);
            Rec."Signature Image".ExportStream(OutS);
            TempBlob.CreateInStream(InS);
            B64 := Base64Conv.ToBase64(InS);
            // Prefix für Canvas in AL ergänzen (PNG-Beispiel)
            CurrPage.ViewPad.LoadSignature('data:image/png;base64,' + B64);
        end else
            CurrPage.ViewPad.LoadSignature('');
    end;
}