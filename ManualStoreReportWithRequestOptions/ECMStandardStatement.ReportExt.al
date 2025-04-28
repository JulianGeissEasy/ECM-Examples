reportextension 61000 "ECM Standard Statement" extends "Standard Statement"
{
    trigger OnPostReport()
    begin
        StoreDocument2ECMQueue(Customer);
    end;

    local procedure StoreDocument2ECMQueue(var Customer: Record Customer)
    var
        ECMDocDef: Record "ECM Document Definition";
        TempECMJnlLine: Record "ECM Document Journal Line" temporary;
        TempMetadataFieldValue: Record "ECM Metadata Field Value" temporary;
        StandardStatement: Report "Standard Statement";
        ECMapi: Codeunit "ECM API";
        ECMGlobals: Codeunit "ECM Globals Variables";
        CustomerRecordRef: RecordRef;
        NVOutStream: OutStream;
        TransactionNo: BigInteger;
        ErrorCode: Integer;
    begin
        if ECMGlobals.GetPDFGenerator() <> '' then
            exit;

        // https://docs.easy-cloud.de/365BC-cloud/de-DE/340852859.html
        // Search document definition
        if not ECMapi.FindDocDefByRRef(ECMDocDef, Customer, ECMDocDef."Purpose of use"::"Assign & File") then begin
            // optional Fehlerhandling
            ECMapi.WriteLog('procedure StandardStatement.StoreDocument2ECMQueue', '', 71, enum::"ECM Message Type"::Information, Customer, 0, TransactionNo);
            exit;
        end;

        CustomerRecordRef.GetTable(Customer);
        CustomerRecordRef.SetRecFilter();

        // Add file to Blob in temporary "ECM Document Journal Line"               
        TempECMJnlLine.Reset();
        TempECMJnlLine.DeleteAll();
        Clear(TempECMJnlLine);

        TempECMJnlLine."Line No." := 10000;
        TempECMJnlLine.File.CreateOutStream(NVOutStream);
        TempECMJnlLine."File Name" := 'Kontoauszug.pdf';

        ECMDocDef."File Name Suggestion" := TempECMJnlLine."File Name";

        // Skip reprint
        ECMGlobals.SetPDFGenerator('StandardStatement');

        // Reprint Report
        StandardStatement.InitializeRequest(CurrReport.PrintEntriesDue, CurrReport.PrintAllHavingEntry, CurrReport.PrintAllHavingBal, CurrReport.PrintReversedEntries, CurrReport.PrintUnappliedEntries, CurrReport.IncludeAgingBand, '', 0, false, CurrReport.StartDate, CurrReport.EndDate);
        StandardStatement.SaveAs('', ReportFormat::Pdf, NVOutStream, CustomerRecordRef);

        // Restore Original State
        ECMGlobals.SetPDFGenerator('');

        // Generate MD5 Hash
        TempECMJnlLine.GenerateMD5Hash();
        // optional Errorhandling
        if TempECMJnlLine.md5 = '' then
            ECMApi.WriteLog('procedure StandardStatement.StoreDocument2ECMQueue', '', 75, Enum::"ECM Message Type"::Warning, Customer, 0, 0);

        TempECMJnlLine.Insert();

        // https://docs.easy-cloud.de/365BC-cloud/de-DE/340623448.html
        // Create an entry in the ECM Queue with file. (File as BLOB in TempECMJnlLine)
        ErrorCode := ECMapi.SaveFileRequest(TempECMJnlLine, TempMetadataFieldValue, ECMDocDef, Customer, TransactionNo);
        if ErrorCode <> 0 then begin
            // optional Errorhandling
            ECMApi.WriteLog('procedure StandardStatement.StoreDocument2ECMQueue', '', ErrorCode, Enum::"ECM Message Type"::Error, Customer, 0, TransactionNo);
            exit;
        end;

        if TransactionNo = 0 then
            exit;

        // Add additional metadata to Queue
        // https://docs.easy-cloud.de/365BC-cloud/de-DE/340590826.html
        ECMapi.SaveReportOption(TransactionNo, 'StartDate', Format(CurrReport.StartDate, 0, 9)); // name 'StartDate' needed for ECM Document Definition Source Field ID
        ECMapi.SaveReportOption(TransactionNo, 'EndDate', Format(CurrReport.EndDate, 0, 9));

        // https://docs.easy-cloud.de/365BC-cloud/de-DE/340754517.html
        // Release Queue for further processing
        ECMapi.ReleaseECMRepositoryRequest(TransactionNo);
    end;
}
