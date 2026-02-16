namespace TrustFort.VATCheck;

page 50201 "TF VAT Validation Results"
{
    Caption = 'VAT Validation Results';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "TF VAT Validation Result";
    Editable = false;
    CardPageId = "TF VAT Validation Detail";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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

                field("Validation Message"; Rec."Validation Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the validation message';
                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the user who performed the validation';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ValidateNew)
            {
                Caption = 'New VAT Check';
                ApplicationArea = All;
                Image = New;
                ToolTip = 'Opens the VAT check page to validate a new VAT number';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Page.Run(Page::"TF VAT Check");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetValidationStyle();
    end;

    var
        ValidationStyle: Text;

    local procedure SetValidationStyle()
    begin
        if Rec."Is Valid" then
            ValidationStyle := 'Favorable'
        else
            ValidationStyle := 'Unfavorable';
    end;
}
