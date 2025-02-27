tableextension 61000 "ECM Custom Journal Line" extends "ECM Document Journal Line"
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
