/// <summary>
/// PageExtension gimQuestions (ID 80004) extends Record MUL SNAD Question List.
/// </summary>
pageextension 80004 gimQuestions extends "MUL SNAD Question List"
{
    layout
    {



    }

    actions
    {
        addlast(Processing)
        {

            action(actCopyQuestions)
            {
                applicationArea = all;
                caption = 'Fragen kopieren';
                image = Copy;
                trigger onAction()
                var
                    gimServotionMgmt: codeunit gimServotionMgmt;
                begin
                    gimServotionMgmt.openDialog(Rec);
                    currpage.update(false);
                end;

            }
        }



    }
}

