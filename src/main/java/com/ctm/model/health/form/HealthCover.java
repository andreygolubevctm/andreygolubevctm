package com.ctm.model.health.form;

public class HealthCover {

    private Insured primary;

    private Insured partner;

    private String rebate;

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
}
