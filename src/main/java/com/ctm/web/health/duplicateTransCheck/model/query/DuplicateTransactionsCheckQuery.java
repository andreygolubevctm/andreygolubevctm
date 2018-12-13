package com.ctm.web.health.duplicateTransCheck.model.query;
public class DuplicateTransactionsCheckQuery {

    private String rootId;
    private String transactionId;
    private String emailAddress;
    private String fullAddress;
    private String mobile;
    private String homePhone;

    public DuplicateTransactionsCheckQuery setData(String rootId, String transactionId, String emailAddress, String fullAddress, String mobile, String homePhone) {
        setRootId(rootId);
        setTransactionId(transactionId);
        setEmailAddress(emailAddress);
        setFullAddress(fullAddress);
        setMobile(mobile);
        setHomePhone(homePhone);
        return this;
    }

    // mutators
    public void setRootId(String rootId) {
        this.rootId = rootId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public void setHomePhone(String homePhone) {
        this.homePhone = homePhone;
    }

    // accessors
    public String getRootId() {
        return rootId;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public String getMobile() {
        return mobile;
    }

    public String getHomePhone() {
        return homePhone;
    }

}
