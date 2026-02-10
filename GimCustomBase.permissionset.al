/// <summary>
/// Unknown _Gim_Custom_Base (ID 80000).
/// </summary>
permissionset 80000 _Gim_Custom_Base
{
    Assignable = true;
    Permissions = codeunit "GIM Custom Events" = X,
        tabledata "sales Shipment Header" = RM,
        page gimItemAPI2 = X,
        page GIM_DatabaseTools = X;


}