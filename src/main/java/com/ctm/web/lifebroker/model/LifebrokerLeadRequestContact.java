package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonProperty;

class LifebrokerLeadRequestContact {

    @JsonProperty("affiliate_id")
    private final String affiliateId;

    private final String email;

    private final String phone;

    private final String postcode;

    private final LifebrokerLeadRequestClient client;

    private final LifebrokerLeadRequestAdditional additional;

    LifebrokerLeadRequestContact(String affiliateId, String email, String phone, String postcode, LifebrokerLeadRequestClient client, LifebrokerLeadRequestAdditional additional) {
        this.affiliateId = affiliateId;
        this.email = email;
        this.phone = phone;
        this.postcode = postcode;
        this.client = client;
        this.additional = additional;
    }

    public String getAffiliateId() {
        return affiliateId;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getPostcode() {
        return postcode;
    }

    public LifebrokerLeadRequestClient getClient() {
        return client;
    }

    public LifebrokerLeadRequestAdditional getAdditional() {
        return additional;
    }
}
