tableextension 61005 "ECM Custom Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(61001; "ECM Custom Order No."; Code[20])
        {
            Caption = 'ECM Custom Order No.';
            DataClassification = CustomerContent;
        }
    }
}
