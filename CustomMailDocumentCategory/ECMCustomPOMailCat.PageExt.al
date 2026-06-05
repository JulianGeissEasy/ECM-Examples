pageextension 61009 "ECM Cust. IO Mail Cat." extends "Purchase Order"
{
    actions
    {
        addlast(processing)
        {
            action(ECMCustomEmailCateory)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send by Email with Custom Category';
                Ellipsis = true;
                Image = Email;
                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                    ECMCustomDocumentCategory: Codeunit "ECM Custom Document Category";
                    ECMDocumentCategory: Record "ECM Document Category";
                    CategoryTok: Label 'CUST-TEST-MAIL', Locked = true;
                begin
                    if not ECMDocumentCategory.Get(CategoryTok) then begin
                        ECMDocumentCategory.Init();
                        ECMDocumentCategory.Code := CategoryTok;
                        ECMDocumentCategory.Description := CategoryTok;
                        ECMDocumentCategory.Insert(true);
                    end;

                    ECMCustomDocumentCategory.SetCategory(ECMDocumentCategory.Code);
                    BindSubscription(ECMCustomDocumentCategory);

                    DocPrint.EmailPurchHeader(Rec);

                    UnbindSubscription(ECMCustomDocumentCategory);
                end;
            }
        }
    }
}