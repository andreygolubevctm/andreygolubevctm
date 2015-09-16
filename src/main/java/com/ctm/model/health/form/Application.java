package com.ctm.model.health.form;

public class Application {

    private Person primary;

    private Person partner;

    private Dependants dependants;

    private Address address;

    private Postal postal;

    private String mobile;

    private String other;

    private String optInEmail;

    private String productTitle;

    private String productId;

    private String provider;

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public Postal getPostal() {
        return postal;
    }

    public void setPostal(Postal postal) {
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

}
