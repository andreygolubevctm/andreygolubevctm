package com.ctm.model;

import com.ctm.model.request.TokenRequest;


public class PageRequest implements TokenRequest {
    private String token;
    private Long transactionId;

    public String getToken(){
        return token;
    }
    public void setToken(String token){
        this.token = token;
    }

    public Long getTransactionId(){
        return transactionId;
    }

    public void setTransactionId(Long transactionId){
        this.transactionId = transactionId;
    }


}
