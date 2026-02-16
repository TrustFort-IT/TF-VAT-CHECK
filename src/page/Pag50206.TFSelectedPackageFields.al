namespace TrustFort.VATCheck;

using System.IO;

page 50206 "TF Selected Package Fields"
{
    Caption = 'Selected Fields';
    PageType = ListPart;
    SourceTable = "Config. Package Field";
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Field ID"; Rec."Field ID")
                {
                    Caption = 'Field ID';
                    ToolTip = 'Specifies the selected field ID.';
                }
                field("Field Name"; Rec."Field Name")
                {
                    Caption = 'Field Name';
                    ToolTip = 'Specifies the selected field name.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    Caption = 'Field Caption';
                    ToolTip = 'Specifies the selected field caption.';
                }
                field("Include Field"; Rec."Include Field")
                {
                    Caption = 'Included';
                    ToolTip = 'Specifies whether the field is included.';
                }
            }
        }
    }
}
