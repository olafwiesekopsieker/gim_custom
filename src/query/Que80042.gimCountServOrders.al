query 80042 "gim Count Serv. Orders"
{
    QueryType = Normal;
    Caption = 'Count Service Orders';

    elements
    {
        dataitem(Service_Header; "Service Header")
        {
            DataItemTableFilter = "Document Type" = const(Order);
            filter(Document_Date; "Document Date") { }
            
            column(Customer_No_; "Customer No.") { }
            column(Ship_to_Code; "Ship-to Code") { }
            
            column(OrderCount)
            {
                Method = Count;
            }
        }
    }
}
