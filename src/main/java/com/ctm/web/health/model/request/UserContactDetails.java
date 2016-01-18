package com.ctm.web.health.model.request;


public class UserContactDetails {

    private String emailAddress;
    private String optinEmailAddress;
    private String emailAddressSecondary;
    private String optOutEmailHistory;
    private String phoneOther;
    private String phoneMobile;
    private String okToCall;

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getOptinEmailAddress() {
        return optinEmailAddress;
    }

    public void setOptinEmailAddress(String optinEmailAddress) {
        this.optinEmailAddress = optinEmailAddress;
    }

    public String getEmailAddressSecondary() {
        return emailAddressSecondary;
    }

    public void setEmailAddressSecondary(String emailAddressSecondary) {
        this.emailAddressSecondary = emailAddressSecondary;
    }

    public String getOptOutEmailHistory() {
        return optOutEmailHistory;
    }

    public void setOptOutEmailHistory(String optOutEmailHistory) {
        this.optOutEmailHistory = optOutEmailHistory;
    }

    public String getPhoneOther() {
        return phoneOther;
    }

    public void setPhoneOther(String phoneOther) {
        this.phoneOther = phoneOther;
    }

    public String getPhoneMobile() {
        return phoneMobile;
    }

    public void setPhoneMobile(String phoneMobile) {
        this.phoneMobile = phoneMobile;
    }

    public String getOkToCall() {
        return okToCall;
    }

    public void setOkToCall(String okToCall) {
        this.okToCall = okToCall;
    }

    @Override
    public String toString() {
        return "UserContactDetails{" +
                "emailAddress=" + emailAddress +
                ", optinEmailAddress='" + optinEmailAddress + '\'' +
                ", emailAddressSecondary='" + emailAddressSecondary + '\'' +
                ", optOutEmailHistory='" + optOutEmailHistory + '\'' +
                ", phoneOther='" + phoneOther + '\'' +
                ", phoneMobile='" + phoneMobile + '\'' +
                ", okToCall='" + okToCall + '\'' +
                '}';
    }
}
