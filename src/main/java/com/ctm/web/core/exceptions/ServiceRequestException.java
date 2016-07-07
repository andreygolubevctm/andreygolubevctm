package com.ctm.web.core.exceptions;

import java.util.HashMap;
import java.util.Map;


public class ServiceRequestException extends RuntimeException {
    private Long transactionId;

    private Map<String, String> errors = new HashMap<>();

    public ServiceRequestException() {
    }

    public ServiceRequestException(String message) {
        super(message);
    }

    public ServiceRequestException( String message, Throwable e) {
        super(message, e);
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public Map<String, String> getErrors() {
        return errors;
    }

    public void setErrors(Map<String, String> errors) {
        this.errors = errors;
    }
}
