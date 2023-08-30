pageextension 88020 DOPBankAccRecon extends "Bank Acc. Reconciliation"
{
    actions
    {
        addfirst("F&unctions")
        {
            action(Action1)
            {
                ApplicationArea = All;
                Caption = 'Recording Reconciliation';
                Image = BankAccountRec;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    BankRecon: Page DOPBankReconciliation;
                begin
                    BankRecon.SetStatementDate(Rec."Statement Date");
                    BankRecon.SetCurrentBankAcc(Rec);
                    BankRecon.RunModal();
                end;
            }
        }
    }
}