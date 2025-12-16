page 61006 "ECM Custom Get Documents"
{
    ApplicationArea = All;
    Caption = 'ECM Custom Get Documents';
    PageType = StandardDialog;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(SelectedInvoiceNo; SelectedInvoiceNo)
                {
                    Caption = 'Selected Invoice No';
                    TableRelation = "Sales Invoice Header";
                    trigger OnValidate()
                    begin
                        GetDocumentsForInvoice(SelectedInvoiceNo);
                    end;
                }
                field(NoOfDocumentEntries; NoOfDocumentEntries)
                {
                    Caption = 'Number of Document Entries';
                    Editable = false;
                }
                field(NoOfFiles; NoOfFiles)
                {
                    Caption = 'Number of Files';
                    Editable = false;
                }
            }
        }
    }

    var
        SelectedInvoiceNo: Code[20];
        NoOfDocumentEntries: Integer;
        NoOfFiles: Integer;

    local procedure GetDocumentsForInvoice(InvoiceNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ECMUser: Record "ECM User";
        ECMDocEntryPrimaryFilter: Record "ECM Doc. Entry Primary filter";
        TempECMDocumentEntryBuffer: Record "ECM Document Entry Buffer" temporary;
        ECMDocumentEntry: Record "ECM Document Entry";
        TempECMDocumentBuffer: Record "ECM Document Buffer" temporary;
        ECMAPI: Codeunit "ECM API";
        DataCompression: Codeunit "Data Compression";
        ZIPTempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        ZIPOutStream: OutStream;
        ErrorCode: Integer;
        FileInStream: InStream;
    begin
        ECMUser.GetDisplayUser('', true, false);
        SalesInvoiceHeader.Get(InvoiceNo);

        TempECMDocumentEntryBuffer.LoadECMEntryWithRRef(TempECMDocumentEntryBuffer, SalesInvoiceHeader, ECMUser, ECMDocEntryPrimaryFilter, 0);

        TempECMDocumentEntryBuffer.Reset();
        TempECMDocumentEntryBuffer.SetFilter("Entry No.", '<>0');

        NoOfDocumentEntries := TempECMDocumentEntryBuffer.Count();
        NoOfFiles := 0;

        if not TempECMDocumentEntryBuffer.FindSet() then
            exit; // no document entries found

        DataCompression.CreateZipArchive();
        repeat
            TempECMDocumentBuffer.Reset();
            TempECMDocumentBuffer.DeleteAll();

            ErrorCode := ECMAPI.GetDocument(TempECMDocumentEntryBuffer."ECM Server Code", TempECMDocumentEntryBuffer."ECM Repository/Library ID", TempECMDocumentEntryBuffer."ECM Repository/Library Ref.", TempECMDocumentEntryBuffer."ECM Document Reference", TempECMDocumentBuffer."Document ID", '', TempECMDocumentBuffer); // get document details from ECM to buffer
            if ErrorCode <> 0 then
                ECMAPI.ShowMessage("ECM OnError"::Error, ErrorCode, '');

            TempECMDocumentBuffer.SetAutoCalcFields(Blob);
            TempECMDocumentBuffer.SetRange("Internal Type", TempECMDocumentBuffer."Internal Type"::File);
            if TempECMDocumentBuffer.FindSet() then // loop through files in buffer for document
                repeat
                    Clear(FileInStream);
                    TempECMDocumentBuffer.Blob.CreateInStream(FileInStream);
                    DataCompression.AddEntry(FileInStream, TempECMDocumentBuffer."ECM File Name"); // add file to zip archive for demo
                    NoOfFiles += 1;
                until TempECMDocumentBuffer.Next() = 0;
        until TempECMDocumentEntryBuffer.Next() = 0;

        ZIPTempBlob.CreateOutStream(ZIPOutStream);
        DataCompression.SaveZipArchive(ZIPOutStream);

        FileManagement.BLOBExport(ZIPTempBlob, 'Documents.zip', true);
    end;
}
