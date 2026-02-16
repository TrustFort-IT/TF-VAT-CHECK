namespace TrustFort.VATCheck;

pageextension 50208 TFVATCheckExt extends "TF VAT Check"
{
    actions
    {
        addlast(Processing)
        {
            action(OpenTFVATProfile)
            {
                Caption = 'TF VAT Profile';
                ApplicationArea = All;
                Image = User;
                ToolTip = 'Open the TF VAT Check profile page.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Page.Run(Page::"TF VAT Check Profile");
                end;
            }
        }
    }
}