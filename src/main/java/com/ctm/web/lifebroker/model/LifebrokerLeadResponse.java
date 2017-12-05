package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.json.XML;

/**
 * Created by msmerdon on 04/12/2017.
 */
@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class LifebrokerLeadResponse {

    private final boolean success;
    private final String message;

    @JsonProperty("client_reference")
    private final String clientReference;

    public LifebrokerLeadResponse(String clientReference) {
        this.message = null;
        this.success = true;
        this.clientReference = clientReference;
    }

    public LifebrokerLeadResponse(Exception e) {
        this.message = e.getMessage();
        this.success = false;
        this.clientReference = null;
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
