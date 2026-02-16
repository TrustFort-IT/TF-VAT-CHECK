namespace TrustFort.VATCheck;

codeunit 50200 "TF VAT Validation Mgt."
{
    Access = Public;

    var
        InvalidVATFormatErr: Label 'The VAT registration number format is invalid for country %1.', Comment = '%1 = Country/Region code';
        NoCountryCodeErr: Label 'Country/Region code must be specified.';

    /// <summary>
    /// Validates a VAT registration number
    /// </summary>
    /// <param name="VATRegNo">The VAT registration number to validate</param>
    /// <param name="CountryCode">The country/region code</param>
    /// <returns>True if the VAT number is valid, otherwise false</returns>
    procedure ValidateVATNumber(VATRegNo: Code[20]; CountryCode: Code[10]): Boolean
    var
        VATValidationResult: Record "TF VAT Validation Result";
        IsValid: Boolean;
        ValidationMessage: Text[250];
    begin
        if CountryCode = '' then
            Error(NoCountryCodeErr);

        // Perform basic validation
        IsValid := PerformVATValidation(VATRegNo, CountryCode, ValidationMessage);

        // Store the validation result
        VATValidationResult.Init();
        VATValidationResult."VAT Registration No." := VATRegNo;
        VATValidationResult."Country/Region Code" := CountryCode;
        VATValidationResult."Is Valid" := IsValid;
        VATValidationResult."Validation Message" := ValidationMessage;
        VATValidationResult.Insert(true);

        exit(IsValid);
    end;

    /// <summary>
    /// Performs VAT number validation with format checking
    /// </summary>
    local procedure PerformVATValidation(VATRegNo: Code[20]; CountryCode: Code[10]; var ValidationMessage: Text[250]): Boolean
    var
        CleanVATNo: Text;
    begin
        // Remove spaces and special characters
        CleanVATNo := DelChr(VATRegNo, '=', ' .-/');

        // Validate based on country code
        case CountryCode of
            'AT': // Austria
                exit(ValidateAustrianVAT(CleanVATNo, ValidationMessage));
            'BE': // Belgium
                exit(ValidateBelgianVAT(CleanVATNo, ValidationMessage));
            'DE': // Germany
                exit(ValidateGermanVAT(CleanVATNo, ValidationMessage));
            'DK': // Denmark
                exit(ValidateDanishVAT(CleanVATNo, ValidationMessage));
            'ES': // Spain
                exit(ValidateSpanishVAT(CleanVATNo, ValidationMessage));
            'FI': // Finland
                exit(ValidateFinnishVAT(CleanVATNo, ValidationMessage));
            'FR': // France
                exit(ValidateFrenchVAT(CleanVATNo, ValidationMessage));
            'GB': // United Kingdom
                exit(ValidateUKVAT(CleanVATNo, ValidationMessage));
            'IE': // Ireland
                exit(ValidateIrishVAT(CleanVATNo, ValidationMessage));
            'IT': // Italy
                exit(ValidateItalianVAT(CleanVATNo, ValidationMessage));
            'NL': // Netherlands
                exit(ValidateDutchVAT(CleanVATNo, ValidationMessage));
            'PT': // Portugal
                exit(ValidatePortugueseVAT(CleanVATNo, ValidationMessage));
            'SE': // Sweden
                exit(ValidateSwedishVAT(CleanVATNo, ValidationMessage));
            else begin
                ValidationMessage := StrSubstNo(InvalidVATFormatErr, CountryCode);
                exit(false);
            end;
        end;
    end;

    local procedure ValidateAustrianVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Austrian VAT: ATU + 8 digits
        if (StrLen(VATNo) = 11) and (CopyStr(VATNo, 1, 3) = 'ATU') then begin
            ValidationMessage := 'Austrian VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Austrian VAT format. Expected: ATU + 8 digits';
        exit(false);
    end;

    local procedure ValidateBelgianVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Belgian VAT: BE + 10 digits
        if (StrLen(VATNo) = 12) and (CopyStr(VATNo, 1, 2) = 'BE') then begin
            ValidationMessage := 'Belgian VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Belgian VAT format. Expected: BE + 10 digits';
        exit(false);
    end;

    local procedure ValidateGermanVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // German VAT: DE + 9 digits
        if (StrLen(VATNo) = 11) and (CopyStr(VATNo, 1, 2) = 'DE') then begin
            ValidationMessage := 'German VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid German VAT format. Expected: DE + 9 digits';
        exit(false);
    end;

    local procedure ValidateDanishVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Danish VAT: DK + 8 digits
        if (StrLen(VATNo) = 10) and (CopyStr(VATNo, 1, 2) = 'DK') then begin
            ValidationMessage := 'Danish VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Danish VAT format. Expected: DK + 8 digits';
        exit(false);
    end;

    local procedure ValidateSpanishVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Spanish VAT: ES + letter/digit + 7 digits + letter/digit
        if (StrLen(VATNo) = 11) and (CopyStr(VATNo, 1, 2) = 'ES') then begin
            ValidationMessage := 'Spanish VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Spanish VAT format. Expected: ES + 9 characters';
        exit(false);
    end;

    local procedure ValidateFinnishVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Finnish VAT: FI + 8 digits
        if (StrLen(VATNo) = 10) and (CopyStr(VATNo, 1, 2) = 'FI') then begin
            ValidationMessage := 'Finnish VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Finnish VAT format. Expected: FI + 8 digits';
        exit(false);
    end;

    local procedure ValidateFrenchVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // French VAT: FR + 2 characters + 9 digits
        if (StrLen(VATNo) = 13) and (CopyStr(VATNo, 1, 2) = 'FR') then begin
            ValidationMessage := 'French VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid French VAT format. Expected: FR + 11 characters';
        exit(false);
    end;

    local procedure ValidateUKVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // UK VAT: GB + 9 or 12 digits
        if (CopyStr(VATNo, 1, 2) = 'GB') and ((StrLen(VATNo) = 11) or (StrLen(VATNo) = 14)) then begin
            ValidationMessage := 'UK VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid UK VAT format. Expected: GB + 9 or 12 digits';
        exit(false);
    end;

    local procedure ValidateIrishVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Irish VAT: IE + 8 characters (letter/digit combinations)
        if (StrLen(VATNo) >= 10) and (CopyStr(VATNo, 1, 2) = 'IE') then begin
            ValidationMessage := 'Irish VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Irish VAT format. Expected: IE + 8 characters';
        exit(false);
    end;

    local procedure ValidateItalianVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Italian VAT: IT + 11 digits
        if (StrLen(VATNo) = 13) and (CopyStr(VATNo, 1, 2) = 'IT') then begin
            ValidationMessage := 'Italian VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Italian VAT format. Expected: IT + 11 digits';
        exit(false);
    end;

    local procedure ValidateDutchVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Dutch VAT: NL + 9 digits + B + 2 digits
        if (StrLen(VATNo) = 14) and (CopyStr(VATNo, 1, 2) = 'NL') then begin
            ValidationMessage := 'Dutch VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Dutch VAT format. Expected: NL + 12 characters';
        exit(false);
    end;

    local procedure ValidatePortugueseVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Portuguese VAT: PT + 9 digits
        if (StrLen(VATNo) = 11) and (CopyStr(VATNo, 1, 2) = 'PT') then begin
            ValidationMessage := 'Portuguese VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Portuguese VAT format. Expected: PT + 9 digits';
        exit(false);
    end;

    local procedure ValidateSwedishVAT(VATNo: Text; var ValidationMessage: Text[250]): Boolean
    begin
        // Swedish VAT: SE + 12 digits
        if (StrLen(VATNo) = 14) and (CopyStr(VATNo, 1, 2) = 'SE') then begin
            ValidationMessage := 'Swedish VAT format is valid';
            exit(true);
        end;
        ValidationMessage := 'Invalid Swedish VAT format. Expected: SE + 12 digits';
        exit(false);
    end;

    /// <summary>
    /// Gets the last validation result for a VAT number
    /// </summary>
    procedure GetLastValidationResult(VATRegNo: Code[20]): Boolean
    var
        VATValidationResult: Record "TF VAT Validation Result";
    begin
        VATValidationResult.SetCurrentKey("VAT Registration No.", "Validation Date");
        VATValidationResult.SetRange("VAT Registration No.", VATRegNo);
        if VATValidationResult.FindLast() then
            exit(VATValidationResult."Is Valid");

        exit(false);
    end;
}
