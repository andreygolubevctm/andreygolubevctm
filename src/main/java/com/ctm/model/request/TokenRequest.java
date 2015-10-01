package com.ctm.model.request;

public interface TokenRequest {

    public String getToken();
    public void setToken(String token);

    public Long getTransactionId();
    public void setTransactionId(Long transactionId);

    public String getIpAddress();
}
