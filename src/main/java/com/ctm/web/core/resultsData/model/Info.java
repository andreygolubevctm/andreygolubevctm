package com.ctm.web.core.resultsData.model;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */

public class Info {

    private String trackingKey;

    private Long transactionId;

    public String getTrackingKey() {
        return trackingKey;
    }

    public void setTrackingKey(String trackingKey) {
        this.trackingKey = trackingKey;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
