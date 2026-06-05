codeunit 61007 "ECM Custom Document Category"
{
    EventSubscriberInstance = Manual;

    var
        Category: Code[20];

    procedure SetCategory(NewCategory: Code[20])
    begin
        Category := NewCategory;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ECM API", 'OnAfterFindDocDefByRRef', '', true, true)]
    local procedure "ECM API_OnAfterFindDocDefByRRef"(var ECMDocDef: Record "ECM Document Definition"; MainRecordVariant: Variant; PurposeofUse: Enum "ECM Purpose Of Use"; ReportID: Integer; var FoundDocDef: Boolean)
    begin
        if FoundDocDef then
            ECMDocDef."Document Category" := Category;
    end;

}