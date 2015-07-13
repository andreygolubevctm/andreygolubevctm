package com.ctm.model.car;

public class Contact {

    private boolean allowCallMeBack;

    private boolean allowCallDirect;

    private String callCentreHours;

    private String phoneNumber;

    public boolean isAllowCallMeBack() {
        return allowCallMeBack;
    }

    public void setAllowCallMeBack(boolean allowCallMeBack) {
        this.allowCallMeBack = allowCallMeBack;
    }

    public boolean isAllowCallDirect() {
        return allowCallDirect;
    }

    public void setAllowCallDirect(boolean allowCallDirect) {
        this.allowCallDirect = allowCallDirect;
    }

    public String getCallCentreHours() {
        return callCentreHours;
    }

    public void setCallCentreHours(String callCentreHours) {
        this.callCentreHours = callCentreHours;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
