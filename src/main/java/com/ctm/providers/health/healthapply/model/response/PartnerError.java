package com.ctm.providers.health.healthapply.model.response;

import com.ctm.healthapply.adapters.util.ErrorCode;
import com.ctm.healthapply.adapters.util.ErrorMessage;
import com.fasterxml.jackson.annotation.JsonProperty;

public class PartnerError {

    private ErrorType type;
    private ErrorCode code;
    private ErrorMessage message;

    public PartnerError(final ErrorType type, final ErrorCode code, final ErrorMessage errorMessage) {
        this.type = type;
        this.code = code;
        this.message = errorMessage;
    }

    public ErrorType getType() {
        return type;
    }

    public ErrorCode getCode() {
        return code;
    }

    public ErrorMessage getMessage() {
        return message;
    }

    @JsonProperty("code")
    private String code() {
        return code.get().orElse(null);
    }

    @JsonProperty("message")
    private String message() {
        return message.get().orElse(null);
    }
}
