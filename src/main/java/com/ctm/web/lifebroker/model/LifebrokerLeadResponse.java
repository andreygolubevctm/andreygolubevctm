package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.json.XML;

/**
 * Created by msmerdon on 04/12/2017.
 */
@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class LifebrokerLeadResponse {

    private boolean success;
    private String message;

    @JsonProperty("client_reference")
    private String clientReference;

    public LifebrokerLeadResponse withClientReference(String clientReference) {
        this.clientReference = clientReference;
        this.success = true;
        return this;
    }

    public LifebrokerLeadResponse withMessage(String message) {
        this.message = message;
        this.success = false;
        return this;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getMessage() {
        return message;
    }

    public String getClientReference() {
        return clientReference;
    }
}
