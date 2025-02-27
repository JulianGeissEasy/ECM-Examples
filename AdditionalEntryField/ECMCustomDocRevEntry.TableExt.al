tableextension 61003 "ECM Custom Doc. Rev. Entry" extends "ECM Document Reversal Entry"
{
    fields
    {
        field(61000; "ECM Custom Item No."; Code[20])
        {
            Caption = 'ECM Custom Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
    }
}
