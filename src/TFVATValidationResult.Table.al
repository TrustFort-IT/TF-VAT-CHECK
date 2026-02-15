namespace TrustFort.VATCheck;

table 50100 "TF VAT Validation Result"
{
    Caption = 'VAT Validation Result';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(3; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(4; "Validation Date"; DateTime)
        {
            Caption = 'Validation Date';
            DataClassification = SystemMetadata;
        }
        field(5; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
            DataClassification = CustomerContent;
        }
        field(6; "Company Name"; Text[250])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(7; "Company Address"; Text[250])
        {
            Caption = 'Company Address';
            DataClassification = CustomerContent;
        }
        field(8; "Validation Message"; Text[250])
        {
            Caption = 'Validation Message';
            DataClassification = CustomerContent;
        }
        field(9; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(VATRegNo; "VAT Registration No.", "Validation Date")
        {
        }
    }

    trigger OnInsert()
    begin
        "Validation Date" := CurrentDateTime();
        "User ID" := CopyStr(UserId(), 1, MaxStrLen("User ID"));
    end;
}
