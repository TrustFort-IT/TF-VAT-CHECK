namespace TrustFort.VATCheck;

using Microsoft.Foundation.Company;

page 50207 "TF VAT Check Profile"
{
    Caption = 'TF VAT Check Profile';
    PageType = Card;
    SourceTable = "Company Information";
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(AppProfile)
            {
                Caption = 'App Profile';

                field(AppName; AppName)
                {
                    Caption = 'App Name';
                    ApplicationArea = All;
                    ToolTip = 'Shows the app name.';
                }

                field(AppVersion; AppVersion)
                {
                    Caption = 'Version';
                    ApplicationArea = All;
                    ToolTip = 'Shows the app version.';
                }

                field(AppPublisher; AppPublisher)
                {
                    Caption = 'Publisher';
                    ApplicationArea = All;
                    ToolTip = 'Shows the app publisher.';
                }
            }

            group(UserProfile)
            {
                Caption = 'User Profile';

                field(CurrentUserId; CurrentUserId)
                {
                    Caption = 'User ID';
                    ApplicationArea = All;
                    ToolTip = 'Shows the current Business Central user ID.';
                }

                field(CurrentCompanyName; CurrentCompanyName)
                {
                    Caption = 'Company';
                    ApplicationArea = All;
                    ToolTip = 'Shows the current company name.';
                }

                field(CurrentWorkDate; CurrentWorkDate)
                {
                    Caption = 'Work Date';
                    ApplicationArea = All;
                    ToolTip = 'Shows the current work date for this session.';
                }

                field(SessionDateTime; SessionDateTime)
                {
                    Caption = 'Current Date/Time';
                    ApplicationArea = All;
                    ToolTip = 'Shows the current date and time.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Init();

        AppName := 'TF VAT Check';
        AppVersion := '1.0.0.0';
        AppPublisher := 'TrustFort IT';

        CurrentUserId := CopyStr(UserId(), 1, MaxStrLen(CurrentUserId));
        CurrentCompanyName := CopyStr(CompanyName(), 1, MaxStrLen(CurrentCompanyName));
        CurrentWorkDate := WorkDate();
        SessionDateTime := CurrentDateTime;
    end;

    var
        AppName: Text[100];
        AppVersion: Text[30];
        AppPublisher: Text[100];
        CurrentUserId: Text[100];
        CurrentCompanyName: Text[100];
        CurrentWorkDate: Date;
        SessionDateTime: DateTime;
}
