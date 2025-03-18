pageextension 80012 gimQestionCard extends "MUL SNAD Question Card"
{
    layout
    {
        Addafter("Question GUID")
        {
            field("Question Group Code"; rec."Question Group Code")
            {
                caption = 'Fragegruppencode';
                visible = true;
                ApplicationARea = all;
            }
        }

    }
}
