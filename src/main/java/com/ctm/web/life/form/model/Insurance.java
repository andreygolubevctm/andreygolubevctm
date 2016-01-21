package com.ctm.web.life.form.model;

import java.math.BigDecimal;

public class Insurance {

    private String frequency;

    private String partner;

    private String samecover;

    private BigDecimal term;

    private BigDecimal tpd;

    private BigDecimal trauma;

    private String tpdanyown;

    private String type;

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getPartner() {
        return partner;
    }

    public void setPartner(String partner) {
        this.partner = partner;
    }

    public String getSamecover() {
        return samecover;
    }

    public void setSamecover(String samecover) {
        this.samecover = samecover;
    }

    public BigDecimal getTerm() {
        return term;
    }

    public void setTerm(BigDecimal term) {
        this.term = term;
    }

    public BigDecimal getTpd() {
        return tpd;
    }

    public void setTpd(BigDecimal tpd) {
        this.tpd = tpd;
    }

    public BigDecimal getTrauma() {
        return trauma;
    }

    public void setTrauma(BigDecimal trauma) {
        this.trauma = trauma;
    }

    public String getTpdanyown() {
        return tpdanyown;
    }

    public void setTpdanyown(String tpdanyown) {
        this.tpdanyown = tpdanyown;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
