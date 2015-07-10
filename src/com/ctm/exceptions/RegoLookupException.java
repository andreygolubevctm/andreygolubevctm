package com.ctm.exceptions;

public class RegoLookupException extends Exception {

    private static final long serialVersionUID = 21651611688654561L;
    private String description;

    public RegoLookupException(String message , Exception e) {
        super(message, e);
    }

    public RegoLookupException(String message) {
        super(message);
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

}
