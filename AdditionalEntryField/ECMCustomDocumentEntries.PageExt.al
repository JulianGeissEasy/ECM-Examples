pageextension 61002 "ECM Custom Document Entries" extends "ECM Document Entries"
{
    layout
    {
        addlast(Control1110300000)
        {
            field("ECM Custom Item No."; Rec."ECM Custom Item No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
