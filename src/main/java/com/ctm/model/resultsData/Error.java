package com.ctm.model.resultsData;

public class Error {

    private final String type;

    private final String message;

    private final Long transactionId;

    private final ErrorDetails errorDetails;

    public Error(String type, String message, Long transactionId, ErrorDetails errorDetails) {
        this.type = type;
        this.message = message;
        this.transactionId = transactionId;
        this.errorDetails = errorDetails;
    }

    public String getType() {
        return type;
    }

    public String getMessage() {
        return message;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public ErrorDetails getErrorDetails() {
        return errorDetails;
    }

}
