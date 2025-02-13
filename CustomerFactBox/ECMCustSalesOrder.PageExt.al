pageextension 61000 "ECM Cust. Sales Order" extends "Sales Order"
{
    layout
    {
        addafter(ECMdocs)
        {
            part(ECMCustomCustomerDocs; "ECM Doc.Entries Buffer FactBox")
            {
                ApplicationArea = All;
                Caption = 'ECM Customer Documents';
                UpdatePropagation = SubPart;
            }
            part(ECMCustomItemDocs; "ECM Doc.Entries Buffer FactBox")
            {
                ApplicationArea = All;
                Caption = 'ECM Item Documents';
                UpdatePropagation = SubPart;
            }
        }
    }

    trigger OnOpenPage()
    var
        TempECMDocEntryPrimaryfilter: Record "ECM Doc. Entry Primary filter" temporary;
    begin
        TempECMDocEntryPrimaryfilter."ECM FactBox UI" := TempECMDocEntryPrimaryfilter."ECM FactBox UI"::"Records Only";
        CurrPage.ECMCustomCustomerDocs.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomCustomerDocs.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);

        CurrPage.ECMCustomItemDocs.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomItemDocs.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);
    end;

    trigger OnAfterGetCurrRecord()
    var
        Item: Record Item;
        ECMDocumentEntry: Record "ECM Document Entry";
    begin
        ECMDocumentEntry.SetRange("Account Type", ECMDocumentEntry."Account Type"::Customer);
        ECMDocumentEntry.SetRange("Account No.", Rec."Sell-to Customer No.");
        CurrPage.ECMCustomCustomerDocs.Page.SetECMEntryView(ECMDocumentEntry);
        CurrPage.ECMCustomCustomerDocs.Page.InitECMEntryBuffer();
        CurrPage.ECMCustomCustomerDocs.Page.Update(false);

        Item.Get('1000');
        CurrPage.ECMCustomItemDocs.Page.LoadDataFromRecord(Item);
    end;
}
