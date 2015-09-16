package com.ctm.model.health.form;

public class Payment {

    private PaymentDetails details;

    private Bank bank;

    private Credit credit;

    public PaymentDetails getDetails() {
        return details;
    }

    public void setDetails(PaymentDetails details) {
        this.details = details;
    }

    public Bank getBank() {
        return bank;
    }

    public void setBank(Bank bank) {
        this.bank = bank;
    }

    public Credit getCredit() {
        return credit;
    }

    public void setCredit(Credit credit) {
        this.credit = credit;
    }
}
