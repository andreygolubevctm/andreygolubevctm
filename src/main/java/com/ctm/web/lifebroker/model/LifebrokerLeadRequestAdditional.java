package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonProperty;

class LifebrokerLeadRequestAdditional {

    @JsonProperty("media_code")
    private final String mediaCode;

    LifebrokerLeadRequestAdditional(String mediaCode) {
        this.mediaCode = mediaCode;
    }

    public String getMediaCode() {
        return mediaCode;
    }
}
