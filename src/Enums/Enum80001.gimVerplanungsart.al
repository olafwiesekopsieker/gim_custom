/// <summary>
/// Enum gimVerplanungsart (ID 80001).
/// </summary>
enum 80001 gimVerplanungsart
{
    Extensible = true;

    value(0; "0")
    {
        Caption = 'unbegrenzt';
    }
    value(1; "1")
    {
        Caption = 'begrenzte Kapazität';
    }
    value(2; "2")
    {
        Caption = 'Volumenbasiert';
    }
    value(3; "3")
    {
        Caption = 'Personalbasierte Planung';
    }
    value(4; "4")
    {
        Caption = '4';
    }
}
