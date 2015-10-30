package com.ctm.providers.health.healthapply.model.response;

public class PartnerError {

    private ErrorType type;
    private String code;
    private String message;
    private Boolean fatal;

    public ErrorType getType() {
        return type;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public Boolean isFatal() {
        return fatal;
    }
}