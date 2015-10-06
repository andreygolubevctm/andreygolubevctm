package com.ctm.model.request;

public interface TokenRequest {

     String getToken();
     void setToken(String token);

     Long getTransactionId();
     void setTransactionId(Long transactionId);
}
