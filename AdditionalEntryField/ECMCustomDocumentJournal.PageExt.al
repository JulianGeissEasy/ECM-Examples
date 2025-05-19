pageextension 61001 "ECM Custom Document Journal" extends "ECM On Hold Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("ECM Custom Item No."; Rec."ECM Custom Item No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
