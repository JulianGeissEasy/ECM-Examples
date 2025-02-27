tableextension 61001 "ECM Custom Document Entry" extends "ECM Document Entry"
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
