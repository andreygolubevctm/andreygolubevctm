package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;


class LifebrokerLeadRequestContact {

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE, localName = "affiliate_id")
    private final String affiliateId;

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
    private final String email;

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
    private final String phone;

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
    private final String postcode;

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE, localName = "Call_time")
    private final String callTime;

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
    private final LifebrokerLeadRequestClient client;

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
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
