pageextension 61007 "ECM Custom Sales Order Line F." extends "Sales Order"
{
    layout
    {
        addafter(ECMdocs)
        {
            part(ECMCustomLineDocs; "ECM Doc.Entries Buffer FactBox")
            {
                Caption = 'ECM Custom Line Docs';
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Table ID" = const(37), "Record SystemId" = field(SystemId);
                UpdatePropagation = SubPart;
            }
        }
    }

    trigger OnOpenPage()
    var
        ECMDocEntryPrimaryfilter: Record "ECM Doc. Entry Primary filter";
    begin
        ECMDocEntryPrimaryfilter."ECM FactBox UI" := ECMDocEntryPrimaryfilter."ECM FactBox UI"::"Records Only"; // either hide here by code or set it in the "ECM Doc. Entry Primary Filter" Page in the client
        CurrPage.ECMCustomLineDocs.Page.SetPageID(Format(Page::"Sales Order Subform", 0, 9));
        CurrPage.ECMCustomLineDocs.Page.SetECMDocEntryPrimaryFilter(ECMDocEntryPrimaryfilter);
    end;
}
