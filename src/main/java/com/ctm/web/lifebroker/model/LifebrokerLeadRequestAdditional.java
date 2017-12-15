package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

class LifebrokerLeadRequestAdditional {

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE, localName = "media_code")
    private final String mediaCode;
    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE, localName = "call_time")
    private final String callTime;

    LifebrokerLeadRequestAdditional(String mediaCode, String callTime) {
        this.mediaCode = mediaCode;
        this.callTime = callTime;
    }

    public String getMediaCode() {
        return mediaCode;
    }

    public String getCallTime() {
        return callTime;
    }
}
