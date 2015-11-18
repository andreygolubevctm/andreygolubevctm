package com.ctm.web.energy.quote.model;

import com.ctm.web.core.quote.model.ContactDetails;


public class EnergyLeadFeedRequest extends EnergyQuoteRequest {

    private String referenceNumber;
    private ContactDetails contactDetails;
    private Integer phoneRating;


    public String getReferenceNumber() {
        return referenceNumber;
    }

    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }

    public ContactDetails getContactDetails() {
        return contactDetails;
    }

    public void setContactDetails(ContactDetails contactDetails) {

        this.contactDetails = contactDetails;
    }

    public Integer getPhoneRating() {
        return phoneRating;
    }
    public void setPhoneRating(Integer phoneRating) {
        this.phoneRating = phoneRating;
    }
}
