package com.ctm.providers.health.healthapply.model.response;

public class PartnerError {

    private ErrorType type;
    private String code;
    private String message;

    public ErrorType getType() {
        return type;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

}
