package com.ctm.web.life.form.response.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

public class Premium {

    @JsonProperty("insurer_contact")
    private String insurerContact;

    @JsonProperty("product_id")
    private String productId;

    private String name;

    private String description;

    @JsonProperty("below_min")
    private String belowMinimum;

    private String company;

    @JsonProperty("service_provider")
    private String serviceProvider;

    private String stars;

    private BigDecimal value;

    private String pds;

    private String info;

    public String getInsurerContact() {
        return insurerContact;
    }

    public void setInsurerContact(String insurerContact) {
        this.insurerContact = insurerContact;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBelowMinimum() {
        return belowMinimum;
    }

    public void setBelowMinimum(String belowMinimum) {
        this.belowMinimum = belowMinimum;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getServiceProvider() {
        return serviceProvider;
    }

    public void setServiceProvider(String serviceProvider) {
        this.serviceProvider = serviceProvider;
    }

    public String getStars() {
        return stars;
    }

    public void setStars(String stars) {
        this.stars = stars;
    }

    public BigDecimal getValue() {
        return value;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }

    public String getPds() {
        return pds;
    }

    public void setPds(String pds) {
        this.pds = pds;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }
}
