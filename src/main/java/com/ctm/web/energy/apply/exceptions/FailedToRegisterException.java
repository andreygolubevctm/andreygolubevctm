package com.ctm.web.energy.apply.exceptions;

import com.ctm.apply.model.response.ApplyResponse;


public class FailedToRegisterException extends RuntimeException {
    private final ApplyResponse applyResponse;
    private final Long transactionId;

    public FailedToRegisterException(ApplyResponse applyResponse, Long transactionId) {
        this.applyResponse = applyResponse;
        this.transactionId = transactionId;
    }

    public ApplyResponse getApplyResponse() {
        return applyResponse;
    }

    public Long getTransactionId() {
        return transactionId;
    }
}
