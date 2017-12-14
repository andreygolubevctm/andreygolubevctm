package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

class LifebrokerLeadRequestAdditional {

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE, localName = "media_code")
    private final String mediaCode;

    LifebrokerLeadRequestAdditional(String mediaCode) {
        this.mediaCode = mediaCode;
    }

    public String getMediaCode() {
        return mediaCode;
    }
}
