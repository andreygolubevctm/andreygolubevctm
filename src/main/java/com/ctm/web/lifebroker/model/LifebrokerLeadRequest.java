package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonRootName;

@JsonRootName("request")
public class LifebrokerLeadRequest {

    private final LifebrokerLeadRequestContact contact;

    public LifebrokerLeadRequest(String affiliateId, String email, String phone, String postcode, String name, String mediaCode) {
        this.contact = new LifebrokerLeadRequestContact(affiliateId, email, phone, postcode, new LifebrokerLeadRequestClient(name), new LifebrokerLeadRequestAdditional(mediaCode));
    }


    public LifebrokerLeadRequestContact getContact() {
        return contact;
    }
}
