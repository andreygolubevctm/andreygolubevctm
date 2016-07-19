package com.ctm.web.life.form.model;

import javax.validation.Valid;

public class LifeQuote {

    private Api api;

    @Valid
    private Applicant primary;

    @Valid
    private Applicant partner;

    private ContactDetails contactDetails;

    public Api getApi() {
        return api;
    }

    public void setApi(Api api) {
        this.api = api;
    }

    public Applicant getPrimary() {
        return primary;
    }

    public void setPrimary(Applicant primary) {
        this.primary = primary;
    }

    public Applicant getPartner() {
        return partner;
    }

    public void setPartner(Applicant partner) {
        this.partner = partner;
    }

    public ContactDetails getContactDetails() {
        return contactDetails;
    }

    public void setContactDetails(ContactDetails contactDetails) {
        this.contactDetails = contactDetails;
    }
}
