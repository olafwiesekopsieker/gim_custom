// report 80001 "Excel Export Lagerreichweite"
// {
//     // c/mt/030614: - Überführung Lagerbuchungsgruppe -> Artikelkategorie
//     // c/gw/030510: - Neuer Report "Excel Export Lagerreichweite"
//     //                in Zusammenarbeit mir JW    - DANKE -
//     //                Jens schrieb im EMail
//     //                   Zwei dinge hab ich geändert:
//     //                     1.    DatumsFilter auf Item
//     //                     -     Hier fehlte bei der Kalkulation der bewegung (Lagerbestand zum Stichtag) der datumsfilter
//     //                     2.    Berechnung Reichweite
//     //                     - Hab ich von den Ermittlung des Datums auf die Anzahl der tage geändert
//     // CC01 24.09.2020 DEMUE.NR # Converted with ForNAV
//     DefaultLayout = RDLC;
//     RDLCLayout = './ExcelExportLagerreichweite.rdlc';


//     dataset
//     {
//         dataitem(Item; Item)
//         {
//             DataItemTableView = SORTING ("No.");
//             RequestFilterFields = "No.";
//             column(USERID; UserId)
//             {
//             }
//             column(ReportForNavPageNo; ReportForNav.PageNo)
//             {
//             }
//             column(COMPANYNAME; CompanyName)
//             {
//             }
//             column(TODAY_0_4; Format(Today, 0, 4))
//             {
//             }
//             column(ValueEntryFIELDCAPTION_ItemNo; "Value Entry".FieldCaption("Item No."))
//             {
//             }
//             dataitem(Location; Location)
//             {
//                 RequestFilterFields = "Code";
//                 dataitem("Value Entry"; "Value Entry")
//                 {
//                     DataItemTableView = SORTING ("Item No.", "Valuation Date", "Location Code", "Variant Code") ORDER(Ascending);
//                     column(Reichweite; _Reichweite)
//                     {
//                     }
//                     column(VerkaufMenge; _VerkaufMenge)
//                     {
//                     }
//                     column(VerbrauchFertigungMenge; _VerbrauchFertigungMenge)
//                     {
//                     }
//                     column(BewertLagBestZumEinstPreis; _BewertLagBestZumEinstPreis)
//                     {
//                     }
//                     column(Code_Location; Location.Code)
//                     {
//                     }
//                     column(InventoryPostingGroup_Item; Item."Inventory Posting Group")
//                     {
//                     }
//                     column(GenProdPostingGroup_Item; Item."Gen. Prod. Posting Group")
//                     {
//                     }
//                     column(Name_Location; Location.Name)
//                     {
//                     }
//                     column(LagerbestandStichtag; _LagerbestandStichtag)
//                     {
//                     }
//                     column(Einstandspreis; _Einstandspreis)
//                     {
//                     }
//                     column(Description_Item; Item.Description)
//                     {
//                     }
//                     column(ItemNo_ValueEntry; "Item No.")
//                     {
//                     }

//                     trigger OnAfterGetRecord()
//                     begin
//                         Find('+');
//                         CalcSums("Cost Amount (Actual)");
//                         _BewertLagBestZumEinstPreis := "Cost Amount (Actual)";
//                         _Einstandspreis := "Cost Amount (Actual)" / _LagerbestandStichtag;
//                         _VerbrauchFertigungMenge := Get_VerbrauchFertigungMenge(Item."No.", Location.Code, Zeitraum);
//                         _VerkaufMenge := Get_VerkaufMenge(Item."No.", Location.Code, Zeitraum);
//                         _Reichweite := Get_Reichweite;
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         SetRange("Item No.", Item."No.");
//                         SetFilter("Location Code", Location.Code);
//                         SetFilter("Valuation Date", StrSubstNo('..%1', Stichtag));
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     Item.SetFilter("Location Filter", Location.Code);
//                     Item.CalcFields("Net Change");
//                     if Item."Net Change" = 0 then
//                         CurrReport.Skip
//                     else
//                         _LagerbestandStichtag := Item."Net Change";
//                 end;
//             }

//             trigger OnPreDataItem()
//             begin
//                 Item.SetFilter("Date Filter", StrSubstNo('..%1', Stichtag));
//             end;
//         }
//     }

//     requestpage
//     {
//         SaveValues = true;

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(Output; Output)
//                     {
//                         Caption = 'Output';
//                     }
//                     field(Stichtag; Stichtag)
//                     {
//                         Caption = 'Stichtag';
//                     }
//                     field(Zeitraum; Zeitraum)
//                     {
//                         Caption = 'Zeitraum';
//                     }
//                     field(_Tage; _Tage)
//                     {
//                         Caption = 'das sind Tage:';
//                     }
//                     field(ForNavOpenDesigner; ReportForNavOpenDesigner)
//                     {
//                         Caption = 'Open Designer';
//                         Visible = ReportForNavAllowDesign;
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnInit()
//         begin
//             Stichtag := Today;
//             Zeitraum := StrSubstNo('%1%2%3', Format(CalcDate('<-1M>', Today + 1)), '..', Today);
//             Init_Zeitraum(Zeitraum);
//             _Tage := Init_Tage(Zeitraum);
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         /*;ReportForNav*/
//         ;
//         ReportsForNavInit();

//     end;

//     trigger OnPostReport()
//     begin
//         if Output = Output::"+ Excel" then
//             ExcelBufferToExcel;
//         ;
//         ReportForNav.Post;
//     end;

//     trigger OnPreReport()
//     begin
//         ;
//         ReportForNav.OpenDesigner := ReportForNavOpenDesigner;
//         if not ReportForNav.Pre then CurrReport.Quit;
//     end;

//     var
//         Stichtag: Date;
//         Zeitraum: Text[30];
//         _Tage: Integer;
//         "- OutputFields ---------------": Char;
//         _Einstandspreis: Decimal;
//         _LagerbestandStichtag: Decimal;
//         _BewertLagBestZumEinstPreis: Decimal;
//         _VerbrauchFertigungMenge: Decimal;
//         _VerkaufMenge: Decimal;
//         _Reichweite: Decimal;
//         "-----------------------XlGlobs": Char;
//         Output: Option Normal,"+ Excel";
//         ExcelBufferTempRec: Record "Excel Buffer" temporary;
//         ExcelBufferCellArr: array[256] of Text[1024];
//         ExcelBufferSubHeaderCellArr: array[1, 12] of Text[1024];
//         ExcelBufferSubHeaderLineCount: Integer;
//         ExcelBufferLineCount: Integer;
//         [WithEvents]
//         ReportForNav: DotNet Report;
//         [RunOnClient]
//         ReportForNavClient: DotNet Report;
//         ReportForNavDialog: Dialog;
//         ReportForNavOpenDesigner: Boolean;
//         [InDataSet]
//         ReportForNavAllowDesign: Boolean;

//     local procedure ReportsForNavInit()
//     var
//         fn: Text;
//     begin
//         fn := ApplicationPath() + 'Add-ins\ReportsForNAV_6_1_0_2106\ForNav.Reports.6.1.0.2106.dll';
//         if not FILE.Exists(ApplicationPath + 'Add-ins\ReportsForNAV_6_1_0_2106\ForNav.Reports.6.1.0.2106.dll') then
//             Error('Please install the ForNAV DLL version 6.1.0.2106 in your service tier Add-ins folder under the file name "%1"', fn);
//         ReportForNav := ReportForNav.Report(CurrReport.ObjectId(), CurrReport.Language(), SerialNumber(), UserId(), CompanyName());
//         ReportForNav.Init();
//     end;

//     local procedure OnPreSectionValueEntry_Body3(var ValueEntry: Record "Value Entry")
//     begin
//         with "Value Entry" do begin
//             if Output = Output::"+ Excel" then begin
//                 ExcelBufferCellArr[1] := StrSubstNo('%1', "Item No.");
//                 ExcelBufferCellArr[2] := StrSubstNo('%1', Item.Description);
//                 ExcelBufferCellArr[3] := StrSubstNo('%1', _Einstandspreis);
//                 ExcelBufferCellArr[4] := StrSubstNo('%1', _LagerbestandStichtag);
//                 ExcelBufferCellArr[5] := StrSubstNo('%1', Location.Name);
//                 ExcelBufferCellArr[6] := StrSubstNo('%1', Item."Gen. Prod. Posting Group");
//                 //c/mt/030614 START
//                 //ExcelBufferCellArr[7] := STRSUBSTNO('%1', Item."Inventory Posting Group");
//                 ExcelBufferCellArr[7] := StrSubstNo('%1', Item."Item Category Code");
//                 //c/mt/030614 STOP
//                 ExcelBufferCellArr[8] := StrSubstNo('%1', Location.Code);
//                 ExcelBufferCellArr[9] := StrSubstNo('%1', _BewertLagBestZumEinstPreis);
//                 ExcelBufferCellArr[10] := StrSubstNo('%1', _VerbrauchFertigungMenge);
//                 ExcelBufferCellArr[11] := StrSubstNo('%1', _VerkaufMenge);
//                 ExcelBufferCellArr[12] := StrSubstNo('%1', _Reichweite);
//                 InitExcelBufferLine(ExcelBufferCellArr);
//             end;
//         end;
//     end;


//     procedure Init_Zeitraum(var Text: Text[1024])
//     var
//         C1: Codeunit ApplicationManagement;
//         D1: Date;
//     begin
//         C1.MakeDateText(Text);
//         if StrPos(Text, '..') = 0 then
//             if Evaluate(D1, Text) then
//                 Text := Format(D1);
//         if StrPos(Text, '..') <> 0 then begin
//             if Evaluate(D1, CopyStr(Text, 1, StrPos(Text, '..') - 1)) then
//                 Text := Format(D1) + CopyStr(Text, StrPos(Text, '..'));
//             if Evaluate(D1, CopyStr(Text, StrPos(Text, '..') + 2)) then
//                 Text := CopyStr(Text, 1, StrPos(Text, '..') + 1) + Format(D1);
//         end;
//         C1.MakeDateFilter(Text);
//     end;


//     procedure Init_Tage(lZeitraum: Text[30]): Integer
//     var
//         lDateRec: Record Date;
//     begin
//         with lDateRec do begin
//             SetRange("Period Type", "Period Type"::Date);
//             SetFilter("Period Start", lZeitraum);
//             exit(Count);
//         end;
//     end;


//     procedure Get_VerbrauchFertigungMenge(pArtikelnr: Code[20]; pLagerortcode: Code[10]; pZeitraum: Text[30]) RetVal: Decimal
//     var
//         lItemRec: Record Item;
//     begin
//         with lItemRec do begin
//             Get(pArtikelnr);
//             SetFilter("Location Filter", pLagerortcode);
//             SetFilter("Date Filter", pZeitraum);
//             CalcFields("Consumption (Qty.)");  // Verbrauch
//             RetVal := "Consumption (Qty.)";
//         end;
//     end;


//     procedure Get_VerkaufMenge(pArtikelnr: Code[20]; pLagerortcode: Code[10]; pZeitraum: Text[30]) RetVal: Decimal
//     var
//         lItemRec: Record Item;
//     begin
//         with lItemRec do begin
//             Get(pArtikelnr);
//             SetFilter("Location Filter", pLagerortcode);
//             SetFilter("Date Filter", pZeitraum);
//             CalcFields("Sales (Qty.)");  // Verkauf
//             RetVal := "Sales (Qty.)";
//         end;
//     end;


//     procedure Get_Reichweite() RetVal: Integer
//     var
//         lTage: Integer;
//     begin
//         if _VerbrauchFertigungMenge + _VerkaufMenge > 0 then begin
//             lTage := Round(_LagerbestandStichtag / ((_VerbrauchFertigungMenge + _VerkaufMenge) / _Tage), 1.0, '<');
//             if lTage > 9999 then
//                 lTage := 9999;  // maximale Zahl fürs CALCDATE
//                                 //RetVal := CALCDATE(STRSUBSTNO('<+%1D>', lTage), Stichtag);
//             RetVal := lTage;
//         end else
//             RetVal := 9999;
//     end;


//     procedure "-----------------------xlfuncs"()
//     begin
//     end;


//     procedure InitExcelSubHeader(): Integer
//     var
//         RowNo: Integer;
//         ColNo: Integer;
//     begin
//         // BEGIN
//         //  ExcelBufferSubHeaderCellArr[1,1] := 'Artikelnr.';
//         //  ExcelBufferSubHeaderCellArr[1,2] := 'Beschreibung';
//         //  ExcelBufferSubHeaderCellArr[1,3] := 'Einstandspreis';
//         //  ExcelBufferSubHeaderCellArr[1,4] := 'Lagerbestand (Stichtag)';
//         //  ExcelBufferSubHeaderCellArr[1,5] := 'Lagerort';
//         //  ExcelBufferSubHeaderCellArr[1,6] := 'Produktbuchungsgruppe';
//         //  //c/mt/030614 START
//         //  //ExcelBufferSubHeaderCellArr[1,7] := 'Lagerbuchungsgruppe';
//         //  ExcelBufferSubHeaderCellArr[1,7] := 'Artikelkategoriencode';
//         //  //c/mt/030614 STOP
//         //  ExcelBufferSubHeaderCellArr[1,8] := 'Lagerortcode';
//         //  ExcelBufferSubHeaderCellArr[1,9] := 'Bewertung Lag-best. z. Einstpr.';
//         //  ExcelBufferSubHeaderCellArr[1,10] := 'Verbauch Fertigung Menge';
//         //  ExcelBufferSubHeaderCellArr[1,11] := 'Verkauf Menge';
//         //  ExcelBufferSubHeaderCellArr[1,12] := 'Reichweite';
//         // END;
//         // FOR RowNo := 1 TO ARRAYLEN(ExcelBufferSubHeaderCellArr,1) DO BEGIN
//         //  FOR ColNo := 1 TO ARRAYLEN(ExcelBufferSubHeaderCellArr,2) DO
//         //    ExcelBufferCellArr[ColNo] := ExcelBufferSubHeaderCellArr[RowNo, ColNo];
//         //  InToExcelBufferCell(RowNo, ExcelBufferCellArr);
//         // END;
//         // EXIT(ARRAYLEN(ExcelBufferSubHeaderCellArr,1));
//     end;


//     procedure InitExcelBufferLine(ExcelBufferCellArr: array[256] of Text[1024])
//     var
//         RowNo: Integer;
//         ColNo: Integer;
//     begin
//         // IF ExcelBufferSubHeaderLineCount = 0 THEN BEGIN
//         //  ExcelBufferSubHeaderLineCount := InitExcelSubHeader;
//         //  ExcelBufferLineCount := ExcelBufferSubHeaderLineCount;
//         // END;
//         // ExcelBufferLineCount += 1;
//         // InToExcelBufferCell(ExcelBufferLineCount, ExcelBufferCellArr);
//     end;


//     procedure InToExcelBufferCell(RowNo: Integer; var LineArr: array[256] of Text[1024])
//     var
//         ColNo: Integer;
//     begin
//         // FOR ColNo := 1 TO ARRAYLEN(ExcelBufferSubHeaderCellArr,2) DO BEGIN
//         //  ExcelBufferTempRec.VALIDATE("Row No.", RowNo);
//         //  ExcelBufferTempRec.VALIDATE("Column No.", ColNo);
//         //  ExcelBufferTempRec.VALIDATE("Cell Value as Text", LineArr[ColNo]);
//         //  ExcelBufferTempRec.INSERT;
//         // END;
//     end;


//     procedure ExcelBufferToExcel()
//     begin
//         // IF ExcelBufferTempRec.COUNT = 0 THEN BEGIN
//         //  MESSAGE('Es gibt nichts in Excel auszugeben')
//         // END ELSE BEGIN
//         //  ExcelBufferTempRec.CreateBook();
//         //  ExcelBufferTempRec.CreateSheet( STRSUBSTNO('Lagerreichweite am %1', Stichtag)
//         //                                , 'R50030 Excel Export Lagerreichweite'
//         //                                , COMPANYNAME
//         //                                , USERID);
//         //  ExcelReportSetFormat;
//         //  ExcelBufferTempRec.GiveUserControl();
//         // END;
//     end;


//     procedure ExcelReportSetFormat()
//     var
//         xlStandardCellWidth: Label '10,71';
//         xlStandardCellHight: Label '12,75';
//         xlSpecCellA1: Label 'A1';
//         xlFirstRow: Label '1';
//         xlLastRow: Label '65536';
//         xlFirstCol: Label 'A';
//         xlLastCol: Label 'IV';
//         xlMinPageWide: Label '1';
//         xlMaxPageWide: Label '32767';
//         xlMinPageTall: Label '1';
//         xlMaxPageTall: Label '32767';
//         xlDefaultIntegerFrmTxt: Label '#.##0;[Rot]-#.##0';
//         xlDefaultCurrencyFrmTxt: Label '#.##0,00;[Rot]-#.##0,00';
//         xlHorzAlignGeneral: Label '1';
//         xlHorzAlignLeft: Label '2';
//         xlHorzAlignlCenter: Label '3';
//         xlHorzAlignRight: Label '4';
//         xlHorzAlignFill: Label '5';
//         xlHorzAlignJustify: Label '6';
//         xlHorzAlignCenterAcrossSelect: Label '7';
//         xlHorzAlignDistributed: Label '8';
//         xlTotalRow: Text[30];
//     begin
//         begin
//             /*
//               // nicht relevant
//               '  ODER'
//               // noch nicht relevant
//             */
//         end;

//     end;

//     trigger ReportForNav::OnInit()
//     var
//         ReportLayoutSelection: Record "Report Layout Selection";
//         CustomReportLayout: Record "Custom Report Layout";
//         CustomLayoutID: Variant;
//         EmptyLayout: Text;
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         EmptyLayout := Format(ReportLayoutSelection."Custom Report Layout ID");
//         CustomLayoutID := ReportLayoutSelection."Custom Report Layout ID";
//         ReportForNav.OData := GetUrl(CLIENTTYPE::OData, CompanyName, OBJECTTYPE::Page, 7702);
//         if Format(ReportLayoutSelection.GetTempLayoutSelected) <> EmptyLayout then
//             CustomLayoutID := ReportLayoutSelection.GetTempLayoutSelected
//         else
//             if ReportLayoutSelection.HasCustomLayout(ReportForNav.ReportID) = 1 then
//                 CustomLayoutID := ReportLayoutSelection."Custom Report Layout ID";

//         if (Format(CustomLayoutID) <> EmptyLayout) and CustomReportLayout.Get(CustomLayoutID) then begin
//             CustomReportLayout.TestField(Type, CustomReportLayout.Type::RDLC);
//             ReportForNav.IsCustomLayout := true;
//         end;

//         if ReportForNav.IsWindowsClient then begin
//             ReportForNav.CheckClientAddIn();
//             ReportForNavClient := ReportForNavClient.Report(ReportForNav.Definition);
//             ReportForNavAllowDesign := ReportForNavClient.HasDesigner and not ReportForNav.ParameterMode;
//         end;
//     end;

//     trigger ReportForNav::OnSave(Base64Layout: Text)
//     var
//         CustomReportLayout: Record "Custom Report Layout";
//         ReportLayoutSelection: Record "Report Layout Selection";
//         LayoutId: Variant;
//         TempBlob: Record TempBlob;
//         OutStream: OutStream;
//         Bstr: BigText;
//         EmptyLayout: Text;
//         ReportID: Integer;
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         EmptyLayout := Format(ReportLayoutSelection."Custom Report Layout ID");
//         LayoutId := ReportLayoutSelection."Custom Report Layout ID";
//         Evaluate(ReportID, Format(ReportForNav.ReportID));
//         if ReportLayoutSelection.HasCustomLayout(ReportID) = 1 then begin
//             if Format(ReportLayoutSelection.GetTempLayoutSelected) <> EmptyLayout then begin
//                 LayoutId := ReportLayoutSelection.GetTempLayoutSelected;
//             end else begin
//                 if ReportLayoutSelection.Get(ReportID, CompanyName) then begin
//                     LayoutId := ReportLayoutSelection."Custom Report Layout ID";
//                 end;
//             end;
//         end;
//         if Format(LayoutId) <> EmptyLayout then begin
//             TempBlob.Blob.CreateOutStream(OutStream);
//             Bstr.AddText(Base64Layout);
//             Bstr.Write(OutStream);
//             CustomReportLayout.Get(LayoutId);
//             CustomReportLayout.ImportLayoutBlob(TempBlob, 'RDL');
//         end;
//     end;

//     trigger ReportForNav::OnParameters(Parameters: Text)
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         ReportForNav.Parameters := REPORT.RunRequestPage(ReportForNav.ReportID, Parameters);
//     end;

//     trigger ReportForNav::OnPreview(Parameters: Text; FileName: Text)
//     var
//         PdfFile: File;
//         InStream: InStream;
//         OutStream: OutStream;
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         Commit;
//         PdfFile.CreateTempFile;
//         PdfFile.CreateOutStream(OutStream);
//         REPORT.SaveAs(ReportForNav.ReportID, Parameters, REPORTFORMAT::Pdf, OutStream);
//         PdfFile.CreateInStream(InStream);
//         if ReportForNav.IsValidPdf(PdfFile.Name) then DownloadFromStream(InStream, '', '', '', FileName);
//         PdfFile.Close;
//     end;

//     trigger ReportForNav::OnPreSection(DataItemId: Text; SectionId: Text)
//     begin
//         case DataItemId of
//             'ValueEntry':
//                 case SectionId of
//                     'Body3':
//                         OnPreSectionValueEntry_Body3("Value Entry");
//                 end;
//         end;
//     end;

//     trigger ReportForNav::OnPostSection(DataItemId: Text; SectionId: Text)
//     begin
//     end;

//     trigger ReportForNav::OnSelectPrinter()
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         ReportForNav.PrinterSettings.PageSettings := ReportForNavClient.SelectPrinter(ReportForNav.PrinterSettings.PrinterName, ReportForNav.PrinterSettings.ShowPrinterDialog, ReportForNav.PrinterSettings.PageSettings);
//     end;

//     trigger ReportForNav::OnPrint(InStream: DotNet Stream)
//     var
//         ClientFileName: Text[255];
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         DownloadFromStream(InStream, '', '<TEMP>', '', ClientFileName);
//         ReportForNavClient.Print(ClientFileName);
//     end;

//     trigger ReportForNav::OnDesign(Data: Text)
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         ReportForNavClient.Data := Data;
//         while ReportForNavClient.DesignReport do begin
//             ReportForNav.HandleRequest(ReportForNavClient.GetRequest());
//             Sleep(100);
//         end;
//     end;

//     trigger ReportForNav::OnView(ClientFileName: Text; Parameters: Text; ServerFileName: Text)
//     var
//         ServerFile: File;
//         ServerInStream: InStream;
//         "Filter": Text;
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         ServerFile.Open(ServerFileName);
//         ServerFile.CreateInStream(ServerInStream);
//         if StrLen(ClientFileName) >= 4 then if LowerCase(CopyStr(ClientFileName, StrLen(ClientFileName) - 3, 4)) = '.pdf' then Filter := 'PDF (*.pdf)|*.pdf';
//         if StrLen(ClientFileName) >= 4 then if LowerCase(CopyStr(ClientFileName, StrLen(ClientFileName) - 3, 4)) = '.doc' then Filter := 'Microsoft Word (*.doc)|*.doc';
//         if StrLen(ClientFileName) >= 5 then if LowerCase(CopyStr(ClientFileName, StrLen(ClientFileName) - 4, 5)) = '.xlsx' then Filter := 'Microsoft Excel (*.xlsx)|*.xlsx';
//         DownloadFromStream(ServerInStream, 'Export', '', Filter, ClientFileName);
//     end;

//     trigger ReportForNav::OnMessage(Operation: Text; Parameter: Text; ParameterNo: Integer)
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         case Operation of
//             'Open':
//                 ReportForNavDialog.Open(Parameter);
//             'Update':
//                 ReportForNavDialog.Update(ParameterNo, Parameter);
//             'Close':
//                 ReportForNavDialog.Close();
//             'Message':
//                 Message(Parameter);
//             'Error':
//                 Error(Parameter);
//         end;
//     end;

//     trigger ReportForNav::OnPrintPreview(InStream: DotNet Stream; Preview: Boolean)
//     var
//         ClientFileName: Text[255];
//     begin
//         // This code is created automatically every time Reports ForNAV saves the report.
//         // Do not modify this code.
//         CurrReport.Language := SYSTEM.GlobalLanguage;
//         DownloadFromStream(InStream, '', '<TEMP>', '', ClientFileName);
//         ReportForNavClient.PrintPreviewDialog(ClientFileName, ReportForNav.PrinterSettings.PrinterName, Preview);
//     end;
// }

