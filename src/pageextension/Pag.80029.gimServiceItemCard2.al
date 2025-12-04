pageextension 80029 gimServiceItemCard2 extends "Service Item Card"
{
    layout
    {
        addafter("Ship-to Phone No.")
        {
            field("Ship-to E-Mail"; Rec."Ship-to E-Mail")
            {
                Applicationarea = all;
                caption = 'lief. an E-Mail';
            }
        }

    }
}
