pageextension 80016 gimWorkCenterCard extends "Work Center Card"
{
    layout
    {
        Addafter(Name)
        {
            field(gimSortOrderEtagis; Rec.gimSortOrderEtagis)
            {
                applicationArea = all;

            }
            field(gimRessourcentyp; Rec.gimRessourcentyp)
            {
                applicationArea = all;

            }
            field(gimVerplanungsart; Rec.gimVerplanungsart)
            {
                applicationArea = all;

            }
        }
    }
}
