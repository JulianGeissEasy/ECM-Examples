pageextension 61004 "ECM Custom Doc.Entries Buffer" extends "ECM Doc.Entries Buffer FactBox"
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
