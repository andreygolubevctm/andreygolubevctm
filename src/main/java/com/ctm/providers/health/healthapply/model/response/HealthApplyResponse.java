package com.ctm.providers.health.healthapply.model.response;

import com.ctm.providers.Response;

public class HealthApplyResponse extends Response<HealthApplicationResponse> {

    private boolean success;

    private String bccEmail;

    private String email;

    private String confirmationID;

    private boolean callcentre;

    private String pendingID;

    public String getBccEmail() {
        return bccEmail;
    }

    public void setBccEmail(String bccEmail) {
        this.bccEmail = bccEmail;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

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

    public boolean isCallcentre() {
        return callcentre;
    }

    public void setCallcentre(boolean callcentre) {
        this.callcentre = callcentre;
    }

    public String getPendingID() {
        return pendingID;
    }

    public void setPendingID(String pendingID) {
        this.pendingID = pendingID;
    }
}
