package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonRootName;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

@JsonRootName(value = "request", namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
public class LifebrokerLeadRequest {

    public static final String LIFEBROKER_NAMESPACE = "urn:Lifebroker.EnterpriseAPI";

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
    private final LifebrokerLeadRequestContact contact;

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
    private final LifebrokerLeadRequestAdditional additional;

    public LifebrokerLeadRequest(String affiliateId, String email, String phone, String postcode, String name, String mediaCode, String callTime) {
        this.contact = new LifebrokerLeadRequestContact(affiliateId, email, phone, postcode, new LifebrokerLeadRequestClient(name));
        this.additional = new LifebrokerLeadRequestAdditional(mediaCode, callTime);
    }


    public LifebrokerLeadRequestContact getContact() {
        return contact;
    }

    public LifebrokerLeadRequestAdditional getAdditional() {
        return additional;
    }
}
