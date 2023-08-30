page 88020 DOPBankReconciliation
{
    PageType = List;
    SourceTable = "Bank Account Ledger Entry";
    Permissions = tabledata "Bank Account Ledger Entry" = m;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Recording Reconciliation';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Reconcile; Rec.DOPReconcile)
                { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = False;
                    Visible = False;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = False;
                    Visible = False;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    Editable = False;
                    Visible = False;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                    Visible = False;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Action1)
            {
                ApplicationArea = All;
                Caption = 'Check / Uncheck';
                Image = SelectLineToApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    BALE: Record "Bank Account Ledger Entry";
                    CU: Codeunit DOPBankReconciliation;
                begin
                    BALE.Reset();
                    CurrPage.SetSelectionFilter(BALE);
                    BALE.Next();

                    repeat
                        if not BALE.DOPReconcile then
                            CU.ReconcileSelected(BALE, true)
                        else
                            CU.ReconcileSelected(BALE, false);
                    until BALE.Next() = 0;
                end;
            }
            action(Action2)
            {
                ApplicationArea = All;
                Caption = 'Run Reconciliation';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SuggestBankAccStatement.SetStmt(CurrentBankAcc);
                    SuggestBankAccStatement.RunModal();
                    CurrPage.Close();
                    Clear(SuggestBankAccStatement);
                end;
            }
        }
    }

    local procedure UpdateBankReconciliationPage(StatementDate: Date)
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Bank Account No.", CurrentBankAcc."Bank Account No.");
        Rec.SetRange(Open, true);
        Rec.SetFilter("Statement Status", Format(Rec."Statement Status"::Open) + '|' + Format(Rec."Statement Status"::"Bank Acc. Entry Applied") + '|' + Format(Rec."Statement Status"::"Check Entry Applied"));
        Rec.SetRange("Posting Date", 0D, StatementDate);
        Rec.FilterGroup(0);
    end;

    procedure SetStatementDate(Date: Date)
    begin
        StatementDate := Date;
    end;

    procedure SetCurrentBankAcc(Bank: Record "Bank Acc. Reconciliation")
    begin
        CurrentBankAcc := Bank;
    end;

    trigger OnOpenPage()
    begin
        UpdateBankReconciliationPage(StatementDate);
    end;

    var
        StatementDate: Date;
        SuggestBankAccStatement: Report DOPBankReconciliation;
        CurrentBankAcc: Record "Bank Acc. Reconciliation";
}