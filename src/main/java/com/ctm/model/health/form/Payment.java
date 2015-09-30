package com.ctm.model.health.form;

public class Payment {

    private PaymentDetails details;

    private Bank bank;

    private Credit credit;

    private Gateway gateway;

    private Medicare medicare;

    private String policyDate;

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

    public Medicare getMedicare() {
        return medicare;
    }

    public void setMedicare(Medicare medicare) {
        this.medicare = medicare;
    }

    public Gateway getGateway() {
        return gateway;
    }

    public void setGateway(Gateway gateway) {
        this.gateway = gateway;
    }

    public String getPolicyDate() {
        return policyDate;
    }

    public void setPolicyDate(String policyDate) {
        this.policyDate = policyDate;
    }
}
