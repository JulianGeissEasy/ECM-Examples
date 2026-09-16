pageextension 61011 "ECM Custom Purch. Invoice Sub." extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field("ECM Custom Order No."; Rec."ECM Custom Order No.")
            {
                ApplicationArea = All;
                Caption = 'ECM Custom Order No.';
            }
        }
    }
}
