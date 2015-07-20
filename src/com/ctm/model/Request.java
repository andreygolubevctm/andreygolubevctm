package com.ctm.model;

public interface Request<QUOTE> {

    Long getTransactionId();

    QUOTE getQuote();

    String getClientIpAddress();

    void setClientIpAddress(String clientIpAddress);
}
