codeunit 61004 "ECM Custom Skip Doc. Export"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ECM API", 'OnBeforeFindDocDefByRRef', '', false, false)]
    local procedure "ECM API_OnBeforeFindDocDefByRRef"(var ECMDocDef: Record "ECM Document Definition"; MainRecordVariant: Variant; PurposeofUse: Enum "ECM Purpose Of Use"; ReportID: Integer; ReporttoECMQueue: Enum "ECM Report to ECM Queue"; var IsHandled: Boolean; var FoundDocDef: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        DataTypeManagement: Codeunit "Data Type Management";
        CurrRecordRef: RecordRef;
    begin
        if not DataTypeManagement.GetRecordRef(MainRecordVariant, CurrRecordRef) then
            exit;

        if CurrRecordRef.Number() <> Database::"Sales Invoice Header" then
            exit;

        CurrRecordRef.SetTable(SalesInvoiceHeader);
        if SalesInvoiceHeader."Sell-to Customer No." = '10000' then begin
            IsHandled := true;
            FoundDocDef := false; // skip processing
        end;
    end;

}
