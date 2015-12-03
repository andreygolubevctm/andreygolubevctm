package com.ctm.web.core.model.formData;

public interface Request {

    Long getTransactionId();

    void setTransactionId(Long transactionId);

    void setClientIpAddress(String clientIpAddress);

    String getClientIpAddress();

    void setEnvironmentOverride(String environmentOverride);

    String getEnvironmentOverride();
}
