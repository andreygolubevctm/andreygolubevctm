package com.ctm.web.core.rememberme.model;

public class RememberMeInfo {

    private boolean rememberMe;

    private boolean userVisitedInLast30Minutes;

    private String transactionId;

    public RememberMeInfo(boolean rememberMe, boolean userVisitedInLast30Minutes, String transactionId) {
        this.rememberMe = rememberMe;
        this.userVisitedInLast30Minutes = userVisitedInLast30Minutes;
        this.transactionId = transactionId;
    }

    public RememberMeInfo(){
        rememberMe = false;

    }


    public boolean isRememberMe() {
        return rememberMe;
    }

    public void setRememberMe(boolean rememberMe) {
        this.rememberMe = rememberMe;
    }

    public boolean isUserVisitedInLast30Minutes() {
        return userVisitedInLast30Minutes;
    }

    public void setUserVisitedInLast30Minutes(boolean userVisitedInLast30Minutes) {
        this.userVisitedInLast30Minutes = userVisitedInLast30Minutes;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
}
