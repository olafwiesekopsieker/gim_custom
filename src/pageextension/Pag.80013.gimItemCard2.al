pageextension 80013 gimItemCard2 extends "Item Card"
{
    layout
    {

    }

    actions
    {
        addlast(processing)
        {
            action(ImportPicNewFunction)
            {
                caption = 'Importiere aus Bilddatenbank (neue Funktion)';

                trigger onaction()
                var
                    PictureDownload: codeunit gim2DownloadImageToItem;
                begin
                    PictureDownload.getItemMetadata(rec."No.");
                end;
            }

        }
    }

}
