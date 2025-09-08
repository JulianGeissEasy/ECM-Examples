page 61000 "ECM Custom Create Doc. Entry"
{
    ApplicationArea = All;
    Caption = 'ECM Custom Create Document Entry';
    PageType = StandardDialog;
    Extensible = false;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            field(AssignRecord; Format(SalesHeader.RecordId()))
            {
                Editable = false;
                Caption = 'Assign ECM Document to record';
            }
            field(ECMDocumentID; ECMDocumentID)
            {
                Caption = 'Unique ECM Document ID';
            }
            field(ECMServerCode; ECMServerCode)
            {
                Caption = 'ECM Server Code';
                TableRelation = "ECM Server";
            }
            field(ECMRepositoryCode; ECMRepositoryCode)
            {
                Caption = 'ECM Repository Code';
                TableRelation = "ECM Repository/Library".Code;
            }
            field(ECMRepositoryRef; ECMRepositoryRef)
            {
                Caption = 'ECM Repository Ref.';
                TableRelation = "ECM Repository/Library"."ECM Repository/Library Ref.";
            }
            field(ECMRepositoryID; ECMRepositoryID)
            {
                Caption = 'ECM Repository ID';
                TableRelation = "ECM Repository/Library"."ECM Repository/Library ID";
            }
            field(ECMDocumentReference; ECMDocumentReference)
            {
                Caption = 'ECM Document Reference';
            }
        }
    }

    var
        SalesHeader: Record "Sales Header";
        ECMServerCode: Code[20];
        ECMRepositoryCode: Code[20];
        ECMDocumentID: Code[36];
        ECMRepositoryRef: Text[350];
        ECMRepositoryID: Text[50];
        ECMDocumentReference: Text[440];

    trigger OnOpenPage()
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.FindFirst(); // find the record, to which you want to assign the document
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ECMDocumentDefinition: Record "ECM Document Definition";
        ECMRepositoryLibrary: Record "ECM Repository/Library";
        TempECMDocumentJournalLine: Record "ECM Document Journal Line" temporary;
        ECMServerMgt: Codeunit "ECM Server Management";
        ECMAPI: Codeunit "ECM API";
        DocRefLength: Integer;
    begin
        if CloseAction = Action::OK then begin
            if not ECMAPI.FindDocDefByRRef(ECMDocumentDefinition, SalesHeader, "ECM Purpose Of Use"::File) then
                Error('No doc. def. found for Record %1.', SalesHeader.RecordId());

            if ECMRepositoryCode = '' then // if Repository Code is not known, Code may change if strucutre is imported again. it is always recommended to find by the Repository by the Repository Ref.
                ECMRepositoryLibrary.FindECMRepCodebyRef(ECMRepositoryLibrary, ECMServerCode, ECMRepositoryRef, ECMRepositoryCode);  // get repository code from Ref. or ID

            if ECMRepositoryCode = '' then // get repository from Document Ref. of EASY ARCHIVE/Sharepoint
                ECMServerMgt.GetRepositoryCode4ECMDocRef(ECMDocumentReference, ECMServerCode, ECMRepositoryCode, ECMRepositoryID, ECMRepositoryRef);

            if '' in [ECMServerCode, ECMRepositoryCode, ECMDocumentReference] then
                Error('Not all fields filled.');

            TempECMDocumentJournalLine.Init();
            TempECMDocumentJournalLine."Line No." := 10000;
            TempECMDocumentJournalLine."Purpose of use" := TempECMDocumentJournalLine."Purpose of use"::Assign;
            TempECMDocumentJournalLine."ECM Server Code" := ECMServerCode;

            TempECMDocumentJournalLine.Validate("ECM Repository/Library Code", ECMRepositoryCode);
            TempECMDocumentJournalLine."ECM Document Reference" := ECMDocumentReference;
            TempECMDocumentJournalLine."File Name" := 'custom assign.pdf';

            // skip auto generate from no. series; get last part of doc. ref.
            if ECMDocumentID = '' then begin
                DocRefLength := StrLen(ECMDocumentReference);
                if DocRefLength <= MaxStrLen(ECMDocumentID) then
                    ECMDocumentID := ECMDocumentReference
                else
                    ECMDocumentID := CopyStr(ECMDocumentReference, DocRefLength - MaxStrLen(ECMDocumentID));
            end;

            ECMDocumentDefinition."Post after Assign if Ready" := true; // auto. post ecm doc. journal line if all information exists
            ECMAPI.AssignECMDocID(TempECMDocumentJournalLine, ECMDocumentDefinition, SalesHeader, ECMDocumentID, false, false, false);
        end;

        exit(true);
    end;
}
