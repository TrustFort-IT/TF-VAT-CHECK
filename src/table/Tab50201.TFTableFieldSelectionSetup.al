namespace TrustFort.VATCheck;

using System.IO;
using System.Reflection;

table 50201 "TF Table Field Selection Setup"
{
    Caption = 'TF Table Field Selection Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Package Code"; Code[20])
        {
            Caption = 'Package Code';
            DataClassification = SystemMetadata;
        }
        field(3; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(4; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Selected Field Count"; Integer)
        {
            Caption = 'Selected Field Count';
            FieldClass = FlowField;
            CalcFormula = count("Config. Package Field" where("Package Code" = field("Package Code"), "Table ID" = field("Table ID"), "Include Field" = const(true)));
            Editable = false;
        }
        field(6; "Field Filter Count"; Integer)
        {
            Caption = 'Field Filter Count';
            FieldClass = FlowField;
            CalcFormula = count("Config. Package Filter" where("Package Code" = field("Package Code"), "Table ID" = field("Table ID")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
