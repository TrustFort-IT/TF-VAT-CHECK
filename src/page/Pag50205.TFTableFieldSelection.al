namespace TrustFort.VATCheck;

using System.IO;
using System.Reflection;

page 50205 "TF Table Field Selection"
{
    Caption = 'TF Table Field Selection';
    PageType = Card;
    SourceTable = "TF Table Field Selection Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the table to configure field selection for.';

                    trigger OnValidate()
                    begin
                        SetTableName();
                        EnsureConfigPackage();
                        EnsureConfigPackageTable();
                        CurrPage.Update(false);
                    end;
                }

                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the selected table name.';
                }

                field("Selected Field Count"; Rec."Selected Field Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the number of selected fields.';
                }

                field("Field Filter Count"; Rec."Field Filter Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the number of field filters.';
                }
            }

            part(SelectedFields; "TF Selected Package Fields")
            {
                ApplicationArea = All;
                SubPageLink = "Package Code" = field("Package Code"), "Table ID" = field("Table ID");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ChooseTable)
            {
                Caption = 'Choose Table';
                ApplicationArea = All;
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Choose the table to configure.';

                trigger OnAction()
                var
                    AllObjWithCaption: Record AllObjWithCaption;
                    Objects: Page Objects;
                begin
                    Clear(Objects);
                    AllObjWithCaption.FilterGroup(2);
                    AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
                    AllObjWithCaption.FilterGroup(0);
                    Objects.SetTableView(AllObjWithCaption);
                    Objects.LookupMode := true;
                    if Objects.RunModal() = Action::LookupOK then begin
                        Objects.GetRecord(AllObjWithCaption);
                        if Rec."Table ID" <> AllObjWithCaption."Object ID" then begin
                            CleanupForTableChange();
                            Rec.Validate("Table ID", AllObjWithCaption."Object ID");
                            Rec.Modify(true);
                        end;
                    end;
                end;
            }

            action(SelectField)
            {
                Caption = 'Select Field';
                ApplicationArea = All;
                Image = SelectField;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select a field from the selected table and include it.';

                trigger OnAction()
                begin
                    SelectFieldFromTable();
                end;
            }

            action(FieldFilters)
            {
                Caption = 'Field Filters';
                ApplicationArea = All;
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Open field filters like Configuration Packages.';

                trigger OnAction()
                begin
                    OpenFieldFilters();
                end;
            }

            action(ClearSelectedFields)
            {
                Caption = 'Clear Selected Fields';
                ApplicationArea = All;
                Image = ClearFilter;
                ToolTip = 'Remove selected fields for the selected table.';

                trigger OnAction()
                var
                    ConfigPackageField: Record "Config. Package Field";
                begin
                    Rec.TestField("Table ID");
                    EnsureConfigPackage();
                    EnsureConfigPackageTable();

                    ConfigPackageField.SetRange("Package Code", Rec."Package Code");
                    ConfigPackageField.SetRange("Table ID", Rec."Table ID");
                    ConfigPackageField.SetRange("Primary Key", false);
                    ConfigPackageField.DeleteAll();

                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnsureSetupRecord();
        SetTableName();
    end;

    var
        ConfigPackageMgt: Codeunit "Config. Package Management";
        FieldSelection: Codeunit "Field Selection";
        DefaultPrimaryKeyLbl: Label 'SETUP';
        DefaultPackageCodeLbl: Label 'TFFLDSEL';
        DefaultPackageNameLbl: Label 'TF Table Field Selection';

    local procedure EnsureSetupRecord()
    begin
        if not Rec.Get(DefaultPrimaryKeyLbl) then begin
            Rec.Init();
            Rec."Primary Key" := DefaultPrimaryKeyLbl;
            Rec."Package Code" := DefaultPackageCodeLbl;
            Rec.Insert(true);
        end;
    end;

    local procedure EnsureConfigPackage()
    var
        ConfigPackage: Record "Config. Package";
    begin
        if Rec."Package Code" = '' then
            Rec."Package Code" := DefaultPackageCodeLbl;

        if not ConfigPackage.Get(Rec."Package Code") then
            ConfigPackageMgt.InsertPackage(ConfigPackage, Rec."Package Code", DefaultPackageNameLbl, true);
    end;

    local procedure EnsureConfigPackageTable()
    var
        ConfigPackageTable: Record "Config. Package Table";
    begin
        if Rec."Table ID" = 0 then
            exit;

        ConfigPackageMgt.InsertPackageTable(ConfigPackageTable, Rec."Package Code", Rec."Table ID");
    end;

    local procedure SetTableName()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if Rec."Table ID" = 0 then begin
            Rec."Table Name" := '';
            exit;
        end;

        if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, Rec."Table ID") then
            Rec."Table Name" := CopyStr(AllObjWithCaption."Object Name", 1, MaxStrLen(Rec."Table Name"))
        else
            Rec."Table Name" := '';
    end;

    local procedure SelectFieldFromTable()
    var
        FieldRec: Record "Field";
        ConfigPackageField: Record "Config. Package Field";
    begin
        Rec.TestField("Table ID");
        EnsureConfigPackage();
        EnsureConfigPackageTable();

        ConfigPackageMgt.SetFieldFilter(FieldRec, Rec."Table ID", 0);
        if not FieldSelection.Open(FieldRec) then
            exit;

        if ConfigPackageField.Get(Rec."Package Code", Rec."Table ID", FieldRec."No.") then begin
            if not ConfigPackageField."Include Field" then begin
                ConfigPackageField.Validate("Include Field", true);
                ConfigPackageField.Modify(true);
            end;
        end else
            ConfigPackageMgt.InsertPackageField(
              ConfigPackageField,
              Rec."Package Code",
              Rec."Table ID",
              FieldRec."No.",
              FieldRec.FieldName,
              FieldRec."Field Caption",
              true,
              true,
              false,
              false);

        CurrPage.Update(false);
    end;

    local procedure OpenFieldFilters()
    var
        ConfigPackageFilter: Record "Config. Package Filter";
    begin
        Rec.TestField("Table ID");
        EnsureConfigPackage();
        EnsureConfigPackageTable();

        ConfigPackageFilter.SetRange("Package Code", Rec."Package Code");
        ConfigPackageFilter.SetRange("Table ID", Rec."Table ID");
        Page.RunModal(Page::"Config. Package Filters", ConfigPackageFilter);
        CurrPage.Update(false);
    end;

    local procedure CleanupForTableChange()
    var
        ConfigPackageField: Record "Config. Package Field";
        ConfigPackageFilter: Record "Config. Package Filter";
        ConfigPackageTable: Record "Config. Package Table";
    begin
        if Rec."Table ID" = 0 then
            exit;

        ConfigPackageField.SetRange("Package Code", Rec."Package Code");
        ConfigPackageField.SetRange("Table ID", Rec."Table ID");
        ConfigPackageField.DeleteAll();

        ConfigPackageFilter.SetRange("Package Code", Rec."Package Code");
        ConfigPackageFilter.SetRange("Table ID", Rec."Table ID");
        ConfigPackageFilter.DeleteAll();

        if ConfigPackageTable.Get(Rec."Package Code", Rec."Table ID") then
            ConfigPackageTable.Delete();
    end;
}
