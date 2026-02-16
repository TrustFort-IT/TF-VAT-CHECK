namespace TrustFort.VATCheck;

using Microsoft.Foundation.Address;

page 50200 "TF VAT Check"
{
    Caption = 'VAT Check';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Input)
            {
                Caption = 'VAT Number Input';

                field(VATRegistrationNo; VATRegistrationNo)
                {
                    Caption = 'VAT Registration No.';
                    ApplicationArea = All;
                    ToolTip = 'Enter the VAT registration number to validate (e.g., DE123456789, GB123456789)';

                    trigger OnValidate()
                    begin
                        ClearValidationResult();
                    end;
                }

                field(CountryRegionCode; CountryRegionCode)
                {
                    Caption = 'Country/Region Code';
                    ApplicationArea = All;
                    TableRelation = "Country/Region";
                    ToolTip = 'Select the country/region code for the VAT number';

                    trigger OnValidate()
                    begin
                        ClearValidationResult();
                    end;
                }
            }

            group(Result)
            {
                Caption = 'Validation Result';
                Visible = ShowResult;

                field(IsValid; IsValid)
                {
                    Caption = 'Valid';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = ValidationStyle;
                    ToolTip = 'Indicates whether the VAT number is valid';
                }

                field(ValidationMessage; ValidationMessage)
                {
                    Caption = 'Validation Message';
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Shows the validation result message';
                }

                field(ValidationDate; ValidationDate)
                {
                    Caption = 'Validation Date';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows when the validation was performed';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Validate)
            {
                Caption = 'Validate VAT Number';
                ApplicationArea = All;
                Image = Check;
                ToolTip = 'Validates the entered VAT registration number';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ValidateVATNumber();
                end;
            }

            action(ViewHistory)
            {
                Caption = 'View Validation History';
                ApplicationArea = All;
                Image = History;
                ToolTip = 'View the history of VAT validations';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Page.Run(Page::"TF VAT Validation Results");
                end;
            }

            action(OpenTableFieldSelection)
            {
                Caption = 'Table & Field Selection';
                ApplicationArea = All;
                Image = SelectEntries;
                ToolTip = 'Open table and field selection including field filters.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Page.Run(Page::"TF Table Field Selection");
                end;
            }

            action(Clear)
            {
                Caption = 'Clear';
                ApplicationArea = All;
                Image = ClearLog;
                ToolTip = 'Clear the current validation';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ClearAll();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        VATValidationMgt: Codeunit "TF VAT Validation Mgt.";
        VATRegistrationNo: Code[20];
        CountryRegionCode: Code[10];
        ValidationMessage: Text[250];
        ValidationDate: DateTime;
        IsValid: Boolean;
        ShowResult: Boolean;
        ValidationStyle: Text;

    local procedure ValidateVATNumber()
    var
        VATValidationResult: Record "TF VAT Validation Result";
    begin
        if VATRegistrationNo = '' then
            Error('Please enter a VAT registration number.');

        if CountryRegionCode = '' then
            Error('Please select a country/region code.');

        IsValid := VATValidationMgt.ValidateVATNumber(VATRegistrationNo, CountryRegionCode);

        // Get the latest validation result
        VATValidationResult.SetCurrentKey("VAT Registration No.", "Validation Date");
        VATValidationResult.SetRange("VAT Registration No.", VATRegistrationNo);
        if VATValidationResult.FindLast() then begin
            ValidationMessage := VATValidationResult."Validation Message";
            ValidationDate := VATValidationResult."Validation Date";
        end;

        ShowResult := true;

        if IsValid then
            ValidationStyle := 'Favorable'
        else
            ValidationStyle := 'Unfavorable';

        CurrPage.Update(false);

        if IsValid then
            Message('VAT number %1 is valid.', VATRegistrationNo)
        else
            Message('VAT number %1 is invalid: %2', VATRegistrationNo, ValidationMessage);
    end;

    local procedure ClearValidationResult()
    begin
        ShowResult := false;
        ValidationMessage := '';
        ValidationDate := 0DT;
        IsValid := false;
        ValidationStyle := '';
    end;

    local procedure ClearAll()
    begin
        VATRegistrationNo := '';
        CountryRegionCode := '';
        ClearValidationResult();
    end;
}
