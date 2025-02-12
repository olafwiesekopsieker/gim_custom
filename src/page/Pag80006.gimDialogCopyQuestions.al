page 80006 gimDialogCopyQuestions
{
    ApplicationArea = All;
    Caption = 'Kopiere Fragegruppen';
    PageType = Card;

    layout
    {
        area(Content)
        {
            field(srcQuestionGroupCode; srcQuestionGroupCode)
            {
                ApplicationArea = All;
                caption = 'Fragegruppencode der Quelle';
                TableRelation = "MUL SNAD Question Group".code;
            }

            field(srcPositionsfilter; srcPositionsfilter)
            {
                ApplicationArea = All;
                caption = 'Positionsfilter';
                ToolTip = 'Beispiel: 1..30|64..67';
            }

            field(trgQuestionGroupCode; trgQuestionGroupCode)
            {
                ApplicationArea = All;
                caption = 'Fragegruppencode des Ziel ';
                Tablerelation = "MUL SNAD Question Group";
            }

            field(trgServicegruppenCode; trgServiceGruppencode)
            {
                ApplicationArea = All;
                caption = 'Servicegruppencode des Ziel';
                TableRelation = "service item group".Code;
            }




        }


    }

    actions
    {
        area(Processing)
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
                    gimServotionMgmt.copyQuestions(srcQuestionGroupCode, srcPositionsfilter, trgQuestionGroupCode, trgServiceGruppencode);
                end;

            }

        }
    }



    var
        srcQuestionGroupCode: Code[20];
        srcPositionsfilter: text;
        trgQuestionGroupCode: Code[20];
        trgServiceGruppencode: Code[30];


    procedure setsrcQuestionGroupCode(locQuestionGroupcode: code[20])
    begin
        srcQuestionGroupcode := locQuestiongroupcode;
    end;
}
