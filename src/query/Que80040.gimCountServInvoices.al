query 80040 "gim Count Serv. Invoices"
{
    QueryType = Normal;
    Caption = 'Count Service Invoices';

    elements
    {
        dataitem(Service_Invoice_Header; "Service Invoice Header")
        {
            filter(Posting_Date; "Posting Date") { }
            
            column(Customer_No_; "Customer No.") { }
            column(Ship_to_Code; "Ship-to Code") { }
            
            column(InvoiceCount)
            {
                Method = Count;
            }
        }
    }
}
