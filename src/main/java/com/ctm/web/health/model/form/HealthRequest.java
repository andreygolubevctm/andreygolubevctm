package com.ctm.web.health.model.form;

import com.ctm.web.core.model.formData.RequestWithQuote;

public class HealthRequest extends RequestWithQuote<HealthQuote> {

    private HealthQuote health;

    @Override
    public HealthQuote getQuote() {
        return health;
    }

    public void setHealth(HealthQuote health) {
        this.health = health;
    }

    public HealthQuote getHealth() {
        return health;
    }

    public String toString() {
        return "HealthQuote{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", health=" + getQuote() +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
