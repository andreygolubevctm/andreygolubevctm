package com.ctm.web.health.model.results;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.List;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class HealthApplicationResult implements HealthResult {

    public long transactionId;

    private boolean success;

    private String confirmationID;

    private Boolean callcentre;

    private String pendingID;

    public List<ResponseError> errors;

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getConfirmationID() {
        return confirmationID;
    }

    public void setConfirmationID(String confirmationID) {
        this.confirmationID = confirmationID;
    }

    public Boolean isCallcentre() {
        return callcentre;
    }

    public void setCallcentre(Boolean callcentre) {
        this.callcentre = callcentre;
    }

    public String getPendingID() {
        return pendingID;
    }

    public void setPendingID(String pendingID) {
        this.pendingID = pendingID;
    }

    public List<ResponseError> getErrors() {
        return errors;
    }

    public void setErrors(List<ResponseError> errors) {
        this.errors = errors;
    }

    //    private HealthApplyResponse result;
//
//    public HealthApplyResponse getResult() {
//        return result;
//    }
//
//    public void setResult(HealthApplyResponse result) {
//        this.result = result;
//    }
}
