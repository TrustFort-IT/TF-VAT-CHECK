namespace TrustFort.VATCheck;

using System.IO;

permissionset 50206 "TF VAT Check"
{
    Assignable = true;
    Caption = 'TF VAT Check';

    Permissions =
        page "TF VAT Check Profile" = X,
        tabledata "TF VAT Validation Result" = RIMD,
        tabledata "TF Table Field Selection Setup" = RIMD,
        tabledata "Config. Package" = RIMD,
        tabledata "Config. Package Table" = RIMD,
        tabledata "Config. Package Field" = RIMD,
        tabledata "Config. Package Filter" = RIMD;
}
