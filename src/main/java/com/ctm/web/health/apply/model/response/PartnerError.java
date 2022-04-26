package com.ctm.web.health.apply.model.response;

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

    public PartnerError(String message) {
        this.message = message;
    }
}