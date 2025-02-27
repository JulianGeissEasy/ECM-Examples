tableextension 61002 "ECM Custom Doc. Entry Buffer" extends "ECM Document Entry Buffer"
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
