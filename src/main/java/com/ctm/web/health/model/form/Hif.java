package com.ctm.web.health.model.form;

public class Hif {

    private String primaryemigrate;

    private String partneremigrate;

    private String partnerrel;

    private String partnerAuthorityLevel;

    public String getPartnerrel() {
        return partnerrel;
    }

    public void setPartnerrel(final String partnerrel) {
        this.partnerrel = partnerrel;
    }


    public String getPrimaryemigrate() {
        return primaryemigrate;
    }

    public void setPrimaryemigrate(String emigrate) {
        this.primaryemigrate = emigrate;
    }

    public String getPartneremigrate() {
        return partneremigrate;
    }

    public void setPartneremigrate(String partneremigrate) {
        this.partneremigrate = partneremigrate;
    }

    public String getPartnerAuthorityLevel() {
        return partnerAuthorityLevel;
    }

    public void setPartnerAuthorityLevel(String partnerAuthorityLevel) {
        this.partnerAuthorityLevel = partnerAuthorityLevel;
    }


}
