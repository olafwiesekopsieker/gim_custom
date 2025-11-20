tableextension 80007 gimProdOrderRtngLine extends "Prod. Order Routing Line"
{
    fields
    {
        field(80001; "etagis Data"; Text[400])
        {
            Caption = 'etagis Data';
            DataClassification = SystemMetadata;
        }
        field(80002; "gimEingeplanteStartzeit"; Datetime)
        {
            caption = 'Eingeplante Startzeit';
            Dataclassification = SystemMetadata;
        }
        field(80003; "gimEingeplanteEndzeit"; Datetime)
        {
            caption = 'Eingeplante Endzeit';
            Dataclassification = SystemMetadata;
        }


    }

    // trigger OnBeforeModify()
    // var
    //     Helper: Codeunit "gimEtagisRedirectHelper";
    // begin
    //     if not Helper.IsFromEtagis() then
    //         exit;

    //     Helper.RedirectPlannedOnModify(
    //         Rec."Starting Date-Time",
    //         Rec."Ending Date-Time",
    //         xRec."Starting Date-Time",
    //         xRec."Ending Date-Time",
    //         Rec."gimEingeplanteStartzeit",
    //         Rec."gimeingeplanteEndzeit");
    // end;
}
