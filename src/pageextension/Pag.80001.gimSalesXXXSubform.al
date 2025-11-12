pageextension 80001 gimSalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }
        // addlast(content)
        // {
        //     field("gimEingeplantes Lieferdatum"; Rec."gimEingeplantes Lieferdatum")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        addafter("Shipment Date")
        {
            field("Planned Shipment Date (etagis)"; rec."Planned Shipment Date (etagis)")
            {
                ApplicationArea = All;
                ToolTip = 'Geplantes Warenausgangsdatum der Zeile (von etagis).';
            }
            field("Status (etagis)"; rec."Status (etagis)")
            {
                ApplicationArea = All;
                ToolTip = 'Etagis-Status der Zeile: unkritisch, ungeplant, kritisch.';
                Style = Strong;
                StyleExpr = LineStatusStyleTxt;
            }
        }



    }


    var
        LineStatusStyleTxt: Text[30];

    trigger OnAfterGetRecord()
    begin
        LineStatusStyleTxt := GetStatusStyle(rec."Status (etagis)");
    end;

    local procedure GetStatusStyle(Status: Option Unkritisch,Ungeplant,Kritisch): Text
    begin
        case Status of
            Status::Unkritisch:
                exit('Favorable');
            Status::Ungeplant:
                exit('Ambiguous');
            Status::Kritisch:
                exit('Attention');
        end;
        exit('');
    end;

}

pageextension 80002 gimSalesInvoiceSubform extends "Sales Invoice Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }
    }
}

pageextension 80018 gimSalesQuoteSubform extends "Sales Quote Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }
    }
}

pageextension 80019 gimSalesCrMemoSubform extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify(Type)
        {
            visible = true;
        }
        modify(FilteredTypeField)
        {
            visible = false;
        }
    }
}
