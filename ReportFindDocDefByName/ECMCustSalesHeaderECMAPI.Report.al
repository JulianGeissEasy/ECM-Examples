report 61000 "ECM Cust. Sales Header ECM API"
{
    ApplicationArea = All;
    Caption = 'ECM Cust. Sales Header with ECM API';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordLayout = './ReportFindDocDefByName/ECMCustSalesHeaderECMAPI.docx';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(DocumentType; "Document Type")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(No; "No.")
            {
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(BilltoName; "Bill-to Name")
            {
            }
            column(BilltoName2; "Bill-to Name 2")
            {
            }
            column(BilltoAddress; "Bill-to Address")
            {
            }
            column(BilltoAddress2; "Bill-to Address 2")
            {
            }
            column(BilltoCity; "Bill-to City")
            {
            }
            column(BilltoContact; "Bill-to Contact")
            {
            }

            trigger OnAfterGetRecord()
            var
                ECMDocumentDefinition: Record "ECM Document Definition";
                ECMAPI: Codeunit "ECM API";
                ErrorCode: Integer;
                TransactionNo: BigInteger;
            begin
                if not ECMAPI.FindDocDefByName(ECMDocumentDefinition, 'ECM API Test', 0D, "ECM Purpose Of Use"::Report) then
                    Error('Document Definition not found.');

                ErrorCode := ECMAPI.ECMRepositoryRequest(ECMDocumentDefinition, SalesHeader, TransactionNo);
                if ErrorCode <> 0 then
                    ECMAPI.ShowMessage("ECM OnError"::Error, ErrorCode, '');

                AfterGetRecordRun := true;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        AfterGetRecordRun: Boolean;

    procedure GetAfterGetRecordRun(): Boolean
    begin
        exit(AfterGetRecordRun);
    end;
}
