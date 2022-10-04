package com.ctm.web.health.model.form;

public class HealthCover {

    private Insured primary;

    private Insured partner;

    private String rebate;

    private Integer income;

    private String adultDependants;

    public Insured getPrimary() {
        return primary;
    }

    public void setPrimary(Insured primary) {
        this.primary = primary;
    }

    public Insured getPartner() {
        return partner;
    }

    public void setPartner(Insured partner) {
        this.partner = partner;
    }

    public String getRebate() {
        return rebate;
    }

    public void setRebate(String rebate) {
        this.rebate = rebate;
    }

    public Integer getIncome() {
        return income;
    }

    public void setIncome(Integer income) {
        this.income = income;
    }

    public String getAdultDependants() {
        return adultDependants;
    }

    public void setAdultDependants(String adultDependants) {
        this.adultDependants = adultDependants;
    }
}
