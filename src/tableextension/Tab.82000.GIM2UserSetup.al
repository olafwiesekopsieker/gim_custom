/// <summary>
/// TableExtension GIM2 User Setup (ID 81200) extends Record User Setup.
/// </summary>
tableextension 80000 "GIM2 User Setup" extends "User Setup"
{
    fields
    {
        field(82000; "gimArtikel sperren erlaubt"; boolean)
        {
            trigger OnValidate()
            var
                UserPermissions: codeunit "User Permissions";
            begin
                if NOT UserPermissions.IsSuper(UserSecurityId()) then
                    Error('Nur Benutzer mit SUPER-Rechten dürfen das Feld <Debitoren sperren erlaubt> ändern');

            end;
        }

    }

    /// <summary>
    /// IsDebitorSperrenErlaubt.
    /// </summary>
    /// <returns>Return value of type boolean.</returns>
    procedure IsArtikelSperrenErlaubt() ret: boolean
    var
        UserSetup: Record "User Setup";
    begin
        ret := false;
        UserSetup.SETRANGE("User ID", UserId());
        IF UserSetup.FINDFIRST then
            exit(UserSetup."gimArtikel sperren erlaubt")
    end;
}
