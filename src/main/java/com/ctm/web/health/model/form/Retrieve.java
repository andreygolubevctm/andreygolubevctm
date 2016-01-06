package com.ctm.web.health.model.form;

public class Retrieve {

    private String savedResults;

    private Long transactionId;

    public String getSavedResults() {
        return savedResults;
    }

    public void setSavedResults(String savedResults) {
        this.savedResults = savedResults;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
