codeunit 80002 gimServotionMgmt
{
    TableNo = "MUL SNAD Question";

    trigger OnRun()
    begin

    end;

    procedure copyQuestions(srcQuestionGroupCode: code[20]; srcPosNoFilter: text; trgQuestionGroupCode: code[20]; trgServiceGruppencode: code[30])
    var
        srcMULSNADQuest: record "MUL SNAD Question";
        trgMULSNADQuest: record "MUL SNAD Question";
        ServotionGenSetup: record "MUL SNAD General Setup";
        NoSeries: codeunit "No. Series";
    begin
        if not ServotionGenSetup.get() then
            ServotionGenSetup.init;

        srcMULSNADQuest.Setrange("Question Group Code", srcQuestionGroupCode);
        srcMULSNADQuest.Setfilter(Position, srcPosNoFilter);
        if srcMULSNADQuest.findset() then
            repeat

                //Kopiere Question
                trgMULSNADQuest := srcMULSNADQuest;
                trgMULSNADQuest.Validate("No.", noSeries.GetNextNo(servotionGenSetup."Question Nos."));
                trgMULSNADQuest.Validate("Question Group Code", trgQuestionGroupCode);
                if not trgMULSNADQuest.INSERT then trgMULSNADQuest.MODIFY;

                copyQuestionConditions(trgQuestionGroupCode, srcMULSNADQuest, trgMULSNADQuest, trgServicegruppencode);

                copyQuestionOptions(srcMULSNADQuest, trgMULSNADQuest);

                copyAnswerConditions(trgQuestionGroupCode, srcMULSNADQuest, trgMULSNADQuest);


            until srcMULSNADQuest.next = 0;

    end;

    local procedure copyQuestionConditions(var trgQuestionGroupCode: code[20]; var srcMULSNADQuest: record "MUL SNAD Question"; var trgMULSNADQuest: record "MUL SNAD Question"; trgServicegruppencode: code[30])
    var
        srcMULSNADQuestCond: record "MUL SNAD Question Condition";
        trgMULSNADQuestCond: record "MUL SNAD Question Condition";
    begin
        //Kopiere Question Condition
        srcMULSNADQuestCond.SETRANGE("Question No.", srcMULSNADQuest."No.");
        if srcMULSNADQuestCond.findset() then
            repeat
                trgMULSNADQuestCond := srcMULSNADQuestCond;
                trgMULSNADQuestCond."Question No." := trgMULSNADQuest."No.";
                trgMULSNADQuestCond."Condition Code" := trgServicegruppencode;
                if not trgMULSNADQuestCond.INSERT then trgMULSNADQuestCond.MODIFY;
            until srcMULSNADQuestCond.next = 0;
    end;

    local procedure copyQuestionOptions(var srcMULSNADQuest: record "MUL SNAD Question"; var trgMULSNADQuest: record "MUL SNAD Question")
    var
        srcMULSNADQuestOpt: record "MUL SNAD Question Option";
        trgMULSNADQuestOpt: record "MUL SNAD Question Option";
    begin
        //Kopiere Question Options
        srcMULSNADQuestOPt.SETRANGE("Question No.", srcMULSNADQuest."No.");
        if srcMULSNADQuestOpt.findset() then
            repeat
                trgMULSNADQuestOpt := srcMULSNADQuestOpt;
                trgMULSNADQuestOpt."Question No." := trgMULSNADQuest."No.";
                if not trgMULSNADQuestOpt.INSERT then trgMULSNADQuestOpt.MODIFY;
            until srcMULSNADQuestOpt.next = 0;
    end;

    local procedure getParentQuestion(var trgParentQuestion: record "MUL SNAD Question"; srcMULSNADAnsCond: record "MUL SNAD Answer Condition"; trgQuestionGroupCode: Code[20]);
    var
        srcParentQuestion: record "MUL SNAD Question";
    begin
        srcParentQuestion.SETRANGE("Question GUID", srcMULSNADAnsCond."Parent Question GUID");
        if srcParentQuestion.findfirst() then begin

            trgParentQuestion.SETRANGE("Question Group Code", trgQuestionGroupCode);
            trgParentQuestion.setrange(Position, srcParentQuestion.Position);
            if trgparentquestion.findfirst() then;
        end;

    end;

    local procedure copyAnswerConditions(var trgQuestionGroupCode: code[20]; var srcMULSNADQuest: record "MUL SNAD Question"; var trgMULSNADQuest: record "MUL SNAD Question")
    var
        srcMULSNADAnswCond: record "MUL SNAD Answer Condition";
        trgMULSNADAnswCond: record "MUL SNAD Answer Condition";
        trgParentQuest: record "mul snad question";
    begin
        //Kopiere Answer Condition
        srcMULSNADAnswCond.SETRANGE("Question No.", srcMULSNADQuest."No.");
        if srcMULSNADAnswCond.findset() then
            repeat
                trgMULSNADAnswCond := srcMULSNADAnswCond;
                trgMULSNADAnswCond."Question No." := trgMULSNADQuest."No.";
                getParentQuestion(trgParentQuest, srcMULSNADAnswCond, trgQuestionGroupCode);
                trgMULSNADAnswCond."Parent Question No." := trgParentQuest."No.";
                trgMULSNADAnswCond."Parent Question GUID" := trgParentQuest.SystemId;
                trgMULSNADAnswCond."Question Group Code" := trgQuestionGroupCode;
                if not trgMULSNADAnswCond.INSERT then trgMULSNADAnswCond.MODIFY;
            until srcMULSNADAnswCond.next = 0;
    end;

    procedure openDialog(var recQuest: record "MUL SNAD Question")

    dlg: page gimDialogCopyQuestions;
    begin
        if recQuest.findfirst then begin
            dlg.setsrcQuestionGroupCode(recQuest."Question Group Code");
            dlg.runmodal;
        end;
    end;

}
