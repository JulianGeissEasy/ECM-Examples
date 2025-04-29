reportextension 61001 "ECM Customer - Balance to Date" extends "Customer - Balance to Date"
{
    dataset
    {
        modify(Customer)
        {
            trigger OnAfterAfterGetRecord()
            begin
                StoreDocumentWithRepositoryRequest();
            end;
        }
    }
    trigger OnPreReport()
    begin
        InitECMReportOptions();
    end;

    local procedure InitECMReportOptions()
    var
        ECMapi: Codeunit "ECM API";
        TransactionNo: BigInteger;
        ReportOptionText: Text;
    begin
        if ECMapi.GetPDFGenerator() = '' then
            exit;

        TransactionNo := ECMapi.GetECMQueueTransNo4CreatePDF();
        if TransactionNo = 0L then
            exit;

        // Save request page values
        ECMAPI.GetReportOption(TransactionNo, 'MaxDate', ReportOptionText);
        if Evaluate(CurrReport.MaxDate, ReportOptionText, 9) then;

        ECMAPI.GetReportOption(TransactionNo, 'PrintAmountInLCY', ReportOptionText);
        if Evaluate(CurrReport.PrintAmountInLCY, ReportOptionText, 9) then;

        ECMAPI.GetReportOption(TransactionNo, 'PrintOnePrPage', ReportOptionText);
        if Evaluate(CurrReport.PrintOnePrPage, ReportOptionText, 9) then;

        ECMAPI.GetReportOption(TransactionNo, 'PrintUnappliedEntries', ReportOptionText);
        if Evaluate(CurrReport.PrintUnappliedEntries, ReportOptionText, 9) then;

        ECMAPI.GetReportOption(TransactionNo, 'ShowEntriesWithZeroBalance', ReportOptionText);
        if Evaluate(CurrReport.ShowEntriesWithZeroBalance, ReportOptionText, 9) then;
    end;

    local procedure StoreDocumentWithRepositoryRequest()
    var
        ECMDocDef: Record "ECM Document Definition";
        ECMapi: Codeunit "ECM API";
        ECMGlobals: Codeunit "ECM Globals Variables";
        TransactionNo: BigInteger;
        ErrorCode: Integer;
    begin
        if ECMAPI.GetPDFGenerator() <> '' then
            exit;

        // https://docs.easy-cloud.de/365BC-cloud/de-DE/340852859.html
        // Search document definition
        if not ECMapi.FindDocDefByRRef(ECMDocDef, Customer, ECMDocDef."Purpose of use"::"Assign & File", Report::"Customer - Balance to Date") then begin
            // optional Fehlerhandling
            ECMapi.WriteLog('procedure ECMCustomerBalanceToDate.StoreDocumentWithRepositoryRequest', '', 71, enum::"ECM Message Type"::Information, Customer, 0, TransactionNo);
            exit;
        end;

        ErrorCode := ECMapi.ECMRepositoryRequest(ECMDocDef, Customer, TransactionNo);
        if ErrorCode <> 0 then
            ECMapi.ShowMessage("ECM OnError"::Error, ErrorCode, '');

        // Add additional metadata to Queue
        // https://docs.easy-cloud.de/365BC-cloud/de-DE/340590826.html
        ECMapi.SaveReportOption(TransactionNo, 'MaxDate', Format(CurrReport.MaxDate, 0, 9)); // name 'StartDate' needed for ECM Document Definition Source Field ID
        ECMapi.SaveReportOption(TransactionNo, 'PrintAmountInLCY', Format(CurrReport.PrintOnePrPage, 0, 9));
        ECMapi.SaveReportOption(TransactionNo, 'PrintOnePrPage', Format(CurrReport.PrintAmountInLCY, 0, 9));
        ECMapi.SaveReportOption(TransactionNo, 'PrintUnappliedEntries', Format(CurrReport.PrintAmountInLCY, 0, 9));
        ECMapi.SaveReportOption(TransactionNo, 'ShowEntriesWithZeroBalance', Format(CurrReport.ShowEntriesWithZeroBalance, 0, 9));

        // https://docs.easy-cloud.de/365BC-cloud/de-DE/340754517.html
        // Release Queue for further processing
        ErrorCode := ECMapi.ReleaseECMRepositoryRequest(TransactionNo);
        if ErrorCode <> 0 then
            ECMapi.ShowMessage("ECM OnError"::Error, ErrorCode, '');
    end;
}
