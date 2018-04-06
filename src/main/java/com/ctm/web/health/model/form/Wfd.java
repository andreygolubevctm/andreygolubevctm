package com.ctm.web.health.model.form;

import com.ctm.web.health.apply.model.request.fundData.Referrer;


public class Wfd {

    private String partnerrel;
    private Referrer referrer;

    public String getPartnerrel() {
        return partnerrel;
    }

    public void setPartnerrel(final String partnerrel) {
        this.partnerrel = partnerrel;
    }

    public Referrer getReferrer() {
        return referrer;
    }

    public void setReferrer(final Referrer referrer) {
        this.referrer = referrer;
    }
}
