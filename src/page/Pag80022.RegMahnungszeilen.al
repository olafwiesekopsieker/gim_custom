page 80022 "Reg. Mahnungszeilen"
{
    ApplicationArea = All;
    Caption = 'Registrierte Mahnungszeilen';
    PageType = List;
    SourceTable = "Issued Reminder Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Reminder Level"; Rec."Reminder Level")
                {
                    ToolTip = 'Specifies the value of the Mahnstufe field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies an entry description, based on the contents of the Type field.';
                }
                field("Detailed Interest Rates Entry"; Rec."Detailed Interest Rates Entry")
                {
                    ToolTip = 'Specifies the value of the Detailed Interest Rates Entry field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number of the customer ledger entry this reminder line is for.';
                }
                field("Verkäufercode GU"; Rec."Verkäufercode GU")
                {
                    ToolTip = 'Specifies the value of the Verkäufercode Gutschrift field.', Comment = '%';
                }
                field("Verkäufercode RE"; Rec."Verkäufercode RE")
                {
                    ToolTip = 'Specifies the value of the Verkäufercode Rechnung field.', Comment = '%';
                }
                field("Verkäufercode SV"; Rec."Verkäufercode SV")
                {
                    ToolTip = 'Specifies the value of the Verkäufercode Service field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the document type of the customer ledger entry this reminder line is for.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the amount in the currency of the reminder.';
                }

                field("Applies-To Document No."; Rec."Applies-To Document No.")
                {
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-To Document Type"; Rec."Applies-To Document Type")
                {
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Attached to Line No."; Rec."Attached to Line No.")
                {
                    ToolTip = 'Specifies the value of the Attached to Line No. field.', Comment = '%';
                }
                field("CCS TM Text Set ID"; Rec."CCS TM Text Set ID")
                {
                    ToolTip = 'Specifies the value of the Text Set ID field.', Comment = '%';
                }
                field(Canceled; Rec.Canceled)
                {
                    ToolTip = 'Specifies the value of the Canceled field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the due date of the customer ledger entry this reminder line is for.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.', Comment = '%';
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ToolTip = 'Specifies the value of the Interest Rate field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ToolTip = 'Specifies the value of the Line Type field.', Comment = '%';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("No. of Reminders"; Rec."No. of Reminders")
                {
                    ToolTip = 'Specifies a number that indicates the reminder level.';
                }
                field("OPP Account No."; Rec."OPP Account No.")
                {
                    ToolTip = 'This field displays the vendor number of the entry in the reminder line if the reminder notice is for a customer/vendor group.';
                }
                field("OPP Entry Type"; Rec."OPP Entry Type")
                {
                    ToolTip = 'This field displays the entry type of the document, which can be a customer or vendor entry.';
                }
                field("OPP Our Account No."; Rec."OPP Our Account No.")
                {
                    ToolTip = 'Here the field our account number from the master data record is displayed.';
                }
                field("OPP Vendor Ledger Entry No."; Rec."OPP Vendor Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Ledger Entry No. field.', Comment = '%';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ToolTip = 'Specifies the original amount of the customer ledger entry that this reminder line is for.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date of the customer ledger entry that this reminder line is for.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ToolTip = 'Specifies the remaining amount of the customer ledger entry this reminder line is for.';
                }
                field("Reminder No."; Rec."Reminder No.")
                {
                    ToolTip = 'Specifies the value of the Reminder No. field.', Comment = '%';
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ToolTip = 'Specifies the value of the System-Created Entry field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ToolTip = 'Specifies the value of the Tax Group Code field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the line type.';
                }
                field("VAT %"; Rec."VAT %")
                {
                    ToolTip = 'Specifies the value of the VAT % field.', Comment = '%';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ToolTip = 'Specifies the VAT amount in the currency of the reminder.';
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ToolTip = 'Specifies the value of the VAT Calculation Type field.', Comment = '%';
                }
                field("VAT Clause Code"; Rec."VAT Clause Code")
                {
                    ToolTip = 'Specifies the value of the VAT Clause Code field.', Comment = '%';
                }
                field("VAT Identifier"; Rec."VAT Identifier")
                {
                    ToolTip = 'Specifies the value of the VAT Identifier field.', Comment = '%';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.', Comment = '%';
                }
            }
        }


    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Document Type", '<>%1', Rec."Document Type"::" ");
    end;
}
