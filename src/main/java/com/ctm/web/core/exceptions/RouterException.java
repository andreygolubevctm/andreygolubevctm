package com.ctm.web.core.exceptions;

import com.ctm.web.core.validation.SchemaValidationError;

import java.util.List;

public class RouterException extends RuntimeException {

    private List<SchemaValidationError> validationErrors;
    private Long transactionId;

    public RouterException(String message) {
        super(message);
    }

    public RouterException(String message, Throwable cause) {
        super(message, cause);
    }

    public RouterException(Throwable cause) {
        super(cause);
    }

    public RouterException(Long transactionId , List<SchemaValidationError> validationErrors) {
        super("Invalid Request");
        this.transactionId = transactionId;
        this.validationErrors = validationErrors;
    }

    public List<SchemaValidationError> getValidationErrors() {
        return validationErrors;
    }

    public Long getTransactionId() {
        return transactionId;
    }
}
