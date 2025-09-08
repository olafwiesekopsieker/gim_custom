table 80001 gimFarbe
{
    Caption = 'gimFarbe';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "RAL Code"; Code[20])
        {
            Caption = 'RAL Code';
        }
        field(10; Beschreibung; Text[150])
        {
            Caption = 'Beschreibung';
        }
        field(20; "Priorität"; Integer)
        {
            Caption = 'Priorität';
        }
        field(25; "RGB"; Code[20])
        {
            Caption = 'RGB';
        }
        field(30; R; Integer)
        {
            Caption = 'R';

            trigger onvalidate()
            begin
                rec.Luminanz := CalculateLuminance();
                rec.RGB := RGBToHex();
            end;
        }
        field(31; G; Integer)
        {
            Caption = 'G';

            trigger onvalidate()
            begin
                rec.Luminanz := CalculateLuminance();
                rec.RGB := RGBToHex();
            end;
        }
        field(32; B; Integer)
        {
            Caption = 'B';

            trigger onvalidate()
            begin
                rec.Luminanz := CalculateLuminance();
                rec.RGB := RGBToHex();
            end;
        }
        field(40; Luminanz; Decimal)
        {
            Caption = 'Luminanz';
            editable = false;
        }

    }
    keys
    {
        key(PK; "RAL Code")
        {
            Clustered = true;
        }
        key(FK01; Luminanz)
        {

        }
        key(FK02; "Priorität")
        {

        }
    }



    procedure CalculateLuminance(): Decimal
    var
        rNorm, gNorm, bNorm : Decimal;
        rLin, gLin, bLin : Decimal;
        Luminance: Decimal;
    begin
        // Normiere R, G, B auf 0..1
        rNorm := rec.R / 255;
        gNorm := rec.G / 255;
        bNorm := rec.B / 255;

        // Gamma-Korrektur rückgängig machen (linearisieren)
        If rNorm <= 0.04045 then
            rLin := rNorm / 12.92
        else
            rLin := Power((rNorm + 0.055) / 1.055, 2.4);

        If gNorm <= 0.04045 then
            gLin := gNorm / 12.92
        else
            gLin := Power((gNorm + 0.055) / 1.055, 2.4);

        If bNorm <= 0.04045 then
            bLin := bNorm / 12.92
        else
            bLin := Power((bNorm + 0.055) / 1.055, 2.4);

        // Luminanz berechnen
        Luminance := 0.2126 * rLin + 0.7152 * gLin + 0.0722 * bLin;

        exit(Luminance); // normierter Wert 0..1
    end;

    procedure RGBToHex(): Text
    var
        Hex: Text;
        rHex: text;
        gHex: Text;
        bHex: Text;
        typeHelper: Codeunit "Type Helper";
    begin

        Hex := '#' +
            Format(Typehelper.IntToHex(rec.R)).PadLeft(2, '0') +
            Format(Typehelper.IntToHex(rec.G)).PadLeft(2, '0') +
            Format(TypeHelper.intToHex(rec.B)).PadLeft(2, '0');
        exit(Hex);
    end;
}
