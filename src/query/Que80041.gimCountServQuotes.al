query 80041 "gim Count Serv. Quotes"
{
    QueryType = Normal;
    Caption = 'Count Service Quotes';

    elements
    {
        dataitem(Service_Header; "Service Header")
        {
            DataItemTableFilter = "Document Type" = const(Quote);
            filter(Document_Date; "Document Date") { }
            
            column(Customer_No_; "Customer No.") { }
            column(Ship_to_Code; "Ship-to Code") { }
            
            column(QuoteCount)
            {
                Method = Count;
            }
        }
    }
}
