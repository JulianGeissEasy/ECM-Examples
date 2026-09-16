tableextension 61006 "ECM Custom Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(61000; "ECM Custom Order No."; Code[20])
        {
            Caption = 'ECM Custom Order No.';
            DataClassification = CustomerContent;
        }
    }
}
