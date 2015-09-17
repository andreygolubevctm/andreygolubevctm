package com.ctm.providers.health.healthapply.model.response;

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

}
