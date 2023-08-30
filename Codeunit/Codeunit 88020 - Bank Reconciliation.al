codeunit 88020 DOPBankReconciliation
{
    Permissions = tabledata "Bank Account Ledger Entry" = m;

    procedure ReconcileSelected(BALE: Record "Bank Account Ledger Entry"; TrueFalse: Boolean)
    begin
        BALE.DOPReconcile := TrueFalse;
        BALE.Modify(false);
    end;
}