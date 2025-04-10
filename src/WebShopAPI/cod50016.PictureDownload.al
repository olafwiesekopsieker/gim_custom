/// <summary>
/// Codeunit gimDownloadImageToItem (ID 50016).
/// </summary>
codeunit 80001 gim2DownloadImageToItem
{


    trigger OnRun()
    var
        item: record item;
    begin
        item.Setrange(Katalog, true);
        if item.FindSet() then
            repeat
                getItemMetadata(item."No.");
            until item.Next() = 0;
    end;

    /// <summary>
    /// ImportItemPictureFromURL.
    /// </summary>
    /// <param name="ItemNo">code[30].</param>
    /// <param name="PictureURL">text.</param>
    procedure ImportItemPictureFromURL(ItemNo: code[30]; PictureURL: text)
    var
        Item: Record Item;
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        Client.Get(PictureURL, Response);
        if response.IsSuccessStatusCode then begin
            Response.Content.ReadAs(InStr);
            if Item.Get(ItemNo) then begin
                Clear(Item.Picture);
                Item.Picture.ImportStream(InStr, 'Demo picture for item ' + Format(Item."No."));
                Item.Modify(true);
            end;
        end;
    end;

    /// <summary>
    /// ExportPDF.
    /// </summary>
    /// <param name="ItemNo">Code[30].</param>
    procedure ExportPDF(ItemNo: Code[30])
    var

        Item: record Item;
        TenantMedia: record "Tenant Media";
        Ins: instream;
        Filename: text;
    begin
        if Item.Get(ItemNo) then begin

            IF TenantMedia.get(item.gimTechDatasheet.Item(1)) then begin
                TenantMedia.calcfields(Content);
                if tenantMedia.content.hasValue then begin
                    filename := 'TechDatasheet ' + ItemNo + '.PDF';
                    tenantMedia.content.CreateinStream(Ins);
                    DownloadFromStream(Ins, '', '', '', Filename);
                end;
            end;
        END;
    end;

    /// <summary>
    /// ImportPDFFromURL.
    /// </summary>
    /// <param name="ItemNo">code[30].</param>
    /// <param name="Languagecode">code[10].</param>
    /// <param name="PDFType">integer.</param>  0: Text; 1: Table

    procedure ImportPDFFromURL(ItemNo: code[30]; Languagecode: text[10]; PDFType: integer)
    var
        Item: Record Item;
        Client: HttpClient;
        // Content: HttpContent;
        PDFURL: text;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        if Languagecode = '' then BEGIN
            // PDFURL := 'https://shop.dueperthal.com/dataSheetGenerator/generate/orderNo/%1/type/%2';
            PDFURL := 'https://pim.dueperthal.com/downloadDatasheet/%1';
            PDFURL := StrSubstNo(PDFURL, ItemNo, PDFType);
        END else BEGIN
            //PDFURL := 'https://shop.dueperthal.com/%1/dataSheetGenerator/generate/orderNo/%2/type/%3';
            PDFURL := 'https://pim.dueperthal.com/downloadDatasheet/%1?lang=%2';
            PDFURL := StrSubstNo(PDFURL, ItemNo, lowercase(LanguageCode), PDFType);
        END;
        Client.Get(PDFURL, Response);
        Response.Content.ReadAs(InStr);
        if Item.Get(ItemNo) then begin
            Clear(Item.gimTechDatasheet);
            Item.gimTechDatasheet.ImportStream(InStr, 'Technisches Datenblatt ' + Format(Item."No."), 'application/pdf');
            Item.Modify(true);
        end;
    end;

    /// <summary>
    /// getItemMetadata.
    /// </summary>
    /// <param name="ItemNo">code[30].</param>
    procedure getItemMetadata(ItemNo: code[30])
    var
        Item: record Item;

        InStr: instream;
        strAccept: text;
        strFTAPIToken: text;
        strURL: text;
        txtContent: text;
        strImageURL: Text;
    begin
        // strAccept:= 'application/vnd.fotoware.assetlist+json';
        // strFTAPIToken:= 'Ybgef3it3$^xyUgj>WwY';
        //strURL := 'https://dueperthal.fotoware.cloud/fotoweb/archives/5023-Products/?q=%1&812=ja&811=ja';  //%1=Artikelnummer
        strURL := 'https://pim.dueperthal.com/showMainImage/%1';
        strURL := StrSubstNo(strURL, ItemNo);
        //getResultFromAPI(strURL, txtContent);
        // message(txtcontent);
        //strImageURL := getImageURL(txtContent);
        //if strImageURL <> 'NOIMAGE' then
        ImportItemPictureFromURL(ItemNo, strImageURL);
    end;

    /// <summary>
    /// getResultFromAPI.
    /// </summary>
    /// <param name="strAPIURI">Text.</param>
    /// <param name="txtContent">VAR text.</param>
    procedure getResultFromAPI(strAPIURI: Text; var txtContent: text)
    var
        RequestMessage: HttpRequestMessage;
        Headers: HttpHeaders;
        Client: HttpClient;
        Response: HttpResponseMessage;
        base64Convert: Codeunit "Base64 Convert";
        AuthenticationString: Text;
        strAccept: text;
        strFWAPIToken: text;
    begin
        begin
            strAccept := 'application/vnd.fotoware.assetlist+json';
            strFWAPIToken := 'Ybgef3it3$^xyUgj>WwY';
            // strAPIURI := 'http://svswb0dynamics1.swb.local:14504/BC14_RESTAPI/ODataV4/Company(''Heinz%20Schwarz%20GmbH%20%26%20Co%20KG'')/SWBProjekte/?$filter= No eq ''20-0528''';
            RequestMessage.GetHeaders(Headers);
            // AuthenticationString := StrSubstNo('%1:%2', 'swb\ow', 'MbL3p7KCr5MnQykeouvL+qmEQJLDtAeR/l+EG2XohXo='); //BC_Schwarz
            Headers.Add('Accept', strAccept);
            Headers.Add('FWAPIToken', strFWAPIToken);


            //StrSubstNo('Basic %1', base64Convert.ToBase64(AuthenticationString)));
            RequestMessage.Method('GET');
            RequestMessage.SetRequestUri(strAPIURI);

            client.Send(RequestMessage, Response);

            IF Response.IsSuccessStatusCode then BEGIN
                response.Content().ReadAs(txtContent);
            END else BEGIN
                error('Statuscode %1', Response.HttpStatusCode);
            END;
        end;
    end;

    Procedure getImageURL(strContent: text) ret: text
    var
        JObject: JsonObject;
        JToken: JsonToken;
        JArray: JsonArray;

        i: integer;

        strAPIURIProjekte: text;
        Projekt: record job;
    BEGIN
        //getData


        //Iterate Data
        JObject.ReadFrom(strcontent);
        Jobject.get('data', JToken);
        JArray := jtoken.asArray();

        if jarray.Count = 0 then begin
            ret := 'NOIMAGE';
            exit;
        end;

        jarray.Get(0, JToken);
        JObject := JToken.AsObject();
        JObject.get('previews', JToken);
        JArray := JToken.asArray();

        jarray.get(0, JToken);
        jObject := Jtoken.asObject();
        jobject.get('href', Jtoken);
        ret := Jtoken.AsValue().AsText();
        ret := StrSubstNo('https://dueperthal.fotoware.cloud%1', ret); ///fotoweb/cache/v2/0/r/Folder%20101/29-200667-0xxL_CLASSIC_M_cl_nL.tif.nyflxfvjMd1hSbFjQA0A.XBfp0NMK_s.jpg'
    end;

}