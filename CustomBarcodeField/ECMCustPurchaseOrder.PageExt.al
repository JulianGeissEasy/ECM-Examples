pageextension 61005 "ECM Cust. Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter("Vendor Shipment No.")
        {
            field("ECM Cust. Barcode Shipment"; Rec."ECM Cust. Barcode Shipment")
            {
                ApplicationArea = All;
                ToolTip = 'The barcode of the shipment.';
                ExtendedDatatype = Barcode;
            }
        }
    }
}
