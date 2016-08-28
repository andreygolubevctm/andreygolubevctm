package com.ctm.web.health.model.form;

public class Retrieve {

    private String SavedResults;

    private Long transactionId;

    public String getSavedResults() {
        return SavedResults;
    }

    public void setSavedResults(String savedResults) {
        this.SavedResults = savedResults;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
