pageextension 61003 "ECM Custom Sales Order 2" extends "Sales Order"
{
    layout
    {
        addafter(ECMdocs)
        {
            part(ECMCustomItemLink; "ECM Doc Entries FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "ECM Custom Item No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    var
        TempECMDocEntryPrimaryfilter: Record "ECM Doc. Entry Primary filter" temporary;
    begin
        TempECMDocEntryPrimaryfilter."ECM FactBox UI" := TempECMDocEntryPrimaryfilter."ECM FactBox UI"::"Records Only";
        CurrPage.ECMCustomItemLink.Page.SetPageID(CurrPage.ObjectId(false));
        CurrPage.ECMCustomItemLink.Page.SetECMDocEntryPrimaryFilter(TempECMDocEntryPrimaryfilter);
    end;
}
