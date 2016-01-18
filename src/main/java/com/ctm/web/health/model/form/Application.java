package com.ctm.web.health.model.form;

public class Application {

    private Person primary;

    private Person partner;

    private Dependants dependants;

    private Address address;

    private Address postal;

    private String mobile;

    private String other;

    private String email;

    private String optInEmail;

    private String productName;

    private String productTitle;

    private String productId;

    private String provider;

    private String providerName;

    private String postalMatch;

    private String contactPoint;

    private String call;

    private Cbh cbh;

    private Hif hif;

    private Qch qch;

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public Address getPostal() {
        return postal;
    }

    public void setPostal(Address postal) {
        this.postal = postal;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getOther() {
        return other;
    }

    public void setOther(String other) {
        this.other = other;
    }

    public String getOptInEmail() {
        return optInEmail;
    }

    public void setOptInEmail(String optInEmail) {
        this.optInEmail = optInEmail;
    }

    public String getProductTitle() {
        return productTitle;
    }

    public void setProductTitle(String productTitle) {
        this.productTitle = productTitle;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public Person getPrimary() {
        return primary;
    }

    public void setPrimary(Person primary) {
        this.primary = primary;
    }

    public Person getPartner() {
        return partner;
    }

    public void setPartner(Person partner) {
        this.partner = partner;
    }

    public Dependants getDependants() {
        return dependants;
    }

    public void setDependants(Dependants dependants) {
        this.dependants = dependants;
    }

    public String getPostalMatch() {
        return postalMatch;
    }

    public void setPostalMatch(String postalMatch) {
        this.postalMatch = postalMatch;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Cbh getCbh() {
        return cbh;
    }

    public void setCbh(Cbh cbh) {
        this.cbh = cbh;
    }

    public String getContactPoint() {
        return contactPoint;
    }

    public void setContactPoint(String contactPoint) {
        this.contactPoint = contactPoint;
    }

    public Hif getHif() {
        return hif;
    }

    public void setHif(Hif hif) {
        this.hif = hif;
    }

    public String getCall() {
        return call;
    }

    public void setCall(String call) {
        this.call = call;
    }

    public Qch getQch() {
        return qch;
    }

    public void setQch(Qch qch) {
        this.qch = qch;
    }
}
