package com.ctm.web.core.model.formData;

public interface Request<QUOTE> {

    Long getTransactionId();

    QUOTE getQuote();

    void setTransactionId(Long transactionId);

    void setClientIpAddress(String clientIpAddress);

    String getEnvironmentOverride();
}
