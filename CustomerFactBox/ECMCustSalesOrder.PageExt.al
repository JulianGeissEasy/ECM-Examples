pageextension 61000 "ECM Cust. Sales Order" extends "Sales Order"
{
    layout
    {
        addafter(ECMdocs)
        {
            part(ECMCustomCustomerDocsWithLink; "ECM Doc.Entries Buffer FactBox") // drop or assign document is possible, record is retrieved by page link and object reference matrix setup
            {
                ApplicationArea = All;
                Caption = 'ECM Customer Documents With Link';
                UpdatePropagation = SubPart;
                SubPageLink = "Table ID" = const(Database::Customer), "Account No." = field("Sell-to Customer No.");
            }
            part(ECMCustomCustomerDocsWithView; "ECM Doc.Entries Buffer FactBox") // drop or assign document is NOT possible
            {
                ApplicationArea = All;
                Caption = 'ECM Customer Documents With View';
                UpdatePropagation = SubPart;
            }
            part(ECMCustomItemDocs; "ECM Doc.Entries Buffer FactBox")  // drop or assign document is possible, record is passed to factbox by code
            {
                ApplicationArea = All;
                Caption = 'ECM Item Documents';
                UpdatePropagation = SubPart;
            }
            part(ECMCustomCustomerDocsUnbuffered; "ECM Doc Entries FactBox") // not using underlying temporary records
            {
                ApplicationArea = All;
                Caption = 'ECM Customer Documents Unbuffered';
                UpdatePropagation = SubPart;
                SubPageLink = "Account No." = field("Sell-to Customer No."), "Account Type" = const(Customer);
            }
        }
    }

    trigger OnOpenPage()
    var
        TempECMDocEntryPrimaryfilter: Record "ECM Doc. Entry Primary filter" temporary;
    begin
        // primary filter to hide drop area
        TempECMDocEntryPrimaryfilter."ECM FactBox UI" := TempECMDocEntryPrimaryfilter."ECM FactBox UI"::"Records Only";

        CurrPage.ECMCustomCustomerDocsWithLink.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomCustomerDocsWithLink.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);

        CurrPage.ECMCustomCustomerDocsWithView.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomCustomerDocsWithView.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);

        CurrPage.ECMCustomItemDocs.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomItemDocs.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);

        CurrPage.ECMCustomCustomerDocsUnbuffered.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomCustomerDocsUnbuffered.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);
    end;

    trigger OnAfterGetCurrRecord()
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ECMDocumentEntry: Record "ECM Document Entry";
    begin
        ECMDocumentEntry.SetRange("Account Type", ECMDocumentEntry."Account Type"::Customer);
        ECMDocumentEntry.SetRange("Account No.", Rec."Sell-to Customer No.");
        CurrPage.ECMCustomCustomerDocsWithView.Page.SetECMEntryView(ECMDocumentEntry);
        CurrPage.ECMCustomCustomerDocsWithView.Page.InitECMEntryBuffer();
        CurrPage.ECMCustomCustomerDocsWithView.Page.Update(false);

        Item.Init();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindFirst() then
            if Item.Get(SalesLine."No.") then;

        CurrPage.ECMCustomItemDocs.Page.LoadDataFromRecord(Item);
    end;
}
