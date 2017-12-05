package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonProperty;

class LifebrokerLeadRequestContact {

    @JsonProperty("affiliate_id")
    private final String affiliateId;

    private final String email;

    private final String phone;

    private final String postcode;

    @JsonProperty("Call_time")
    private final String callTime;

    private final LifebrokerLeadRequestClient client;

    private final LifebrokerLeadRequestAdditional additional;

    LifebrokerLeadRequestContact(String affiliateId, String email, String phone, String postcode, String callTime, LifebrokerLeadRequestClient client, LifebrokerLeadRequestAdditional additional) {
        this.affiliateId = affiliateId;
        this.email = email;
        this.phone = phone;
        this.postcode = postcode;
        this.client = client;
        this.additional = additional;
        this.callTime = callTime;
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

    public String getCallTime() {
        return callTime;
    }

    public LifebrokerLeadRequestClient getClient() {
        return client;
    }

    public LifebrokerLeadRequestAdditional getAdditional() {
        return additional;
    }
}
