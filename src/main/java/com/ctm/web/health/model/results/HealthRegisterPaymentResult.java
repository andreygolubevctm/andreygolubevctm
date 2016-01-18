package com.ctm.web.health.model.results;

public class HealthRegisterPaymentResult implements HealthResult {

    private boolean success;

    @Override
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
