tableextension 61004 "ECM Cust. Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(61000; "ECM Cust. Barcode Shipment"; Code[36])
        {
            Caption = 'Barcode Shipment';
            DataClassification = CustomerContent;
            ExtendedDatatype = Barcode;

            trigger OnValidate()
            var
                ECMDocumentDefinition: Record "ECM Document Definition";
                TempECMJournalLine: Record "ECM Document Journal Line" temporary;
                ECMAPI: Codeunit "ECM API";
                ErrorCode: Integer;
            begin
                if Rec."ECM Cust. Barcode Shipment" = '' then
                    exit;

                if not ECMAPI.FindDocDefByRRef(ECMDocumentDefinition, Rec, "ECM Purpose Of use"::Assign) then
                    Error('No document definition found for the current record.');

                ErrorCode := ECMAPI.AssignECMDocID(TempECMJournalLine, ECMDocumentDefinition, Rec, Rec."ECM Cust. Barcode Shipment", false, true, false);
                if ErrorCode <> 0 then
                    ECMAPI.ShowMessage("ECM OnError"::Message, ErrorCode, '');
            end;
        }
    }
}
