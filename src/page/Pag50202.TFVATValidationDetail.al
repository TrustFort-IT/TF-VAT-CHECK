namespace TrustFort.VATCheck;

page 50202 "TF VAT Validation Detail"
{
    Caption = 'VAT Validation Detail';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "TF VAT Validation Result";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the entry number';
                }

                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the VAT registration number';
                }

                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the country/region code';
                }

                field("Is Valid"; Rec."Is Valid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the VAT number is valid';
                    StyleExpr = ValidationStyle;
                }

                field("Validation Date"; Rec."Validation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the validation date';
                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the user who performed the validation';
                }
            }

            group(Details)
            {
                Caption = 'Details';

                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the company name (if available)';
                }

                field("Company Address"; Rec."Company Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the company address (if available)';
                }

                field("Validation Message"; Rec."Validation Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the validation message';
                    MultiLine = true;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Is Valid" then
            ValidationStyle := 'Favorable'
        else
            ValidationStyle := 'Unfavorable';
    end;

    var
        ValidationStyle: Text;
}
