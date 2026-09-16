# Line FactBox

Shows how to embed the **ECM Doc.Entries Buffer FactBox** for documents of a **subpage record** (here: the selected sales line).

The FactBox uses `Provider = SalesLines` and links via `Table ID` / `Record SystemId`, so it follows the current line. Drop/assign is possible for that line record. `ECM FactBox UI` = **Records Only** hides the drop area.

For header-related / filtered FactBox variants on the same Sales Order page, see [CustomerFactBox](../CustomerFactBox/).

```al
part(ECMCustomLineDocs; "ECM Doc.Entries Buffer FactBox")
{
    Caption = 'ECM Custom Line Docs';
    ApplicationArea = All;
    Provider = SalesLines;
    SubPageLink = "Table ID" = const(37), "Record SystemId" = field(SystemId);
    UpdatePropagation = SubPart;
}
```
