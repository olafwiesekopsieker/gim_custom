pageextension 80013 gimItemCard2 extends "Item Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field(gimNichtInEtagisPlanen; rec.gimNichtInEtagisPlanen)
            {
                applicationArea = all;
            }
        }
    }

    actions
    {
        addlast(navigation)
        {
            action(ImportPicNewFunction)
            {
                caption = 'Importiere aus Bilddatenbank (neue Funktion)';
                ApplicationArea = All;

                trigger onaction()
                var
                    PictureDownload: codeunit gim2DownloadImageToItem;
                begin
                    PictureDownload.getItemMetadata(rec."No.");
                    CurrPage.Update(false);
                end;
            }

        }
        modify(TestBilddatenbank)
        {
            visible = false;
        }
    }

}
