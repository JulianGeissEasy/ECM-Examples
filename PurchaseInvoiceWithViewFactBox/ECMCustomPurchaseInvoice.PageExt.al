pageextension 61010 "ECM Custom Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("ECM Custom Order No."; Rec."ECM Custom Order No.")
            {
                ApplicationArea = All;
                Caption = 'ECM Custom Order No.';
            }
        }
        addafter(ECMdocs)
        {
            part(ECMCustomPurchaseInvoiceDocsWithView; "ECM Doc.Entries Buffer FactBox")
            {
                ApplicationArea = All;
                Caption = 'ECM Purchase Invoice Documents With View';
                UpdatePropagation = SubPart;
            }
        }
    }

    trigger OnOpenPage()
    var
        TempECMDocEntryPrimaryfilter: Record "ECM Doc. Entry Primary filter" temporary;
    begin
        TempECMDocEntryPrimaryfilter."ECM FactBox UI" := TempECMDocEntryPrimaryfilter."ECM FactBox UI"::"Records Only"; // hide dropzone

        CurrPage.ECMCustomPurchaseInvoiceDocsWithView.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomPurchaseInvoiceDocsWithView.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);
    end;

    trigger OnAfterGetCurrRecord()
    var
        ECMDocumentEntry: Record "ECM Document Entry";
        PurchaseLine: Record "Purchase Line";
        FilterTextBuilder: TextBuilder;
    begin
        FilterTextBuilder.Append(Rec."ECM Custom Order No.");

        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetLoadFields("ECM Custom Order No.");
        if PurchaseLine.FindSet() then
            repeat
                if PurchaseLine."ECM Custom Order No." <> '' then
                    if FilterTextBuilder.Length() = 0 then
                        FilterTextBuilder.Append(PurchaseLine."ECM Custom Order No.")
                    else
                        FilterTextBuilder.Append('|' + PurchaseLine."ECM Custom Order No.");
            until PurchaseLine.Next() = 0;

        ECMDocumentEntry.SetFilter("Document No.", FilterTextBuilder.ToText());
        CurrPage.ECMCustomPurchaseInvoiceDocsWithView.Page.SetECMEntryView(ECMDocumentEntry);
        CurrPage.ECMCustomPurchaseInvoiceDocsWithView.Page.LoadDataFromRecord(Rec); // set record for droppig and assign file
    end;


}
