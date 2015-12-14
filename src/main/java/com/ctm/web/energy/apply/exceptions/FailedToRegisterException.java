package com.ctm.web.energy.apply.exceptions;

import com.ctm.apply.model.response.ApplyResponse;


public class FailedToRegisterException extends RuntimeException {
    private final ApplyResponse applyResponse;

    public FailedToRegisterException(ApplyResponse applyResponse) {
        this.applyResponse = applyResponse;
    }

    public ApplyResponse getApplyResponse() {
        return applyResponse;
    }
}
