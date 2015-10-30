package com.ctm.model.health.results;

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
