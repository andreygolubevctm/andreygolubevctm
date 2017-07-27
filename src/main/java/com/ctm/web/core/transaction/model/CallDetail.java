package com.ctm.web.core.transaction.model;

public class CallDetail {

    private String callIdKey;

    private Integer transactionId;

    public CallDetail(String callIdKey, Integer transactionId) {
        this.callIdKey = callIdKey;
        this.transactionId = transactionId;
    }

    public String getCallIdKey() {
        return callIdKey;
    }

    public Integer getTransactionId() {
        return transactionId;
    }
}
