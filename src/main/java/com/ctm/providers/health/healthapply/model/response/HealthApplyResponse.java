package com.ctm.providers.health.healthapply.model.response;

import com.ctm.providers.Response;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class HealthApplyResponse extends Response<HealthApplicationResponse> {

    private boolean success;

    private String confirmationID;

    private Boolean callcentre;

    private String pendingID;

    public String getConfirmationID() {
        return confirmationID;
    }

    public void setConfirmationID(String confirmationID) {
        this.confirmationID = confirmationID;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Boolean getCallcentre() {
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
}
