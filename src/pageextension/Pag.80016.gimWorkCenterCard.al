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
        }
    }
}
