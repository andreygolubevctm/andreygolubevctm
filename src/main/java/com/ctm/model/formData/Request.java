package com.ctm.model.formData;

public interface Request<QUOTE> {

    Long getTransactionId();

    QUOTE getQuote();

    void setTransactionId(Long transactionId);

    void setClientIpAddress(String clientIpAddress);
}
