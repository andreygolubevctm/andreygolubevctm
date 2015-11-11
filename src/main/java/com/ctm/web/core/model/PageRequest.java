package com.ctm.web.core.model;

import com.ctm.web.core.model.request.TokenRequest;


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

    public String toString(){
        return "PageRequest {" +
                "token:" + token + "," +
                "transactionId:" + transactionId + "" +
                "}";
    }


}
