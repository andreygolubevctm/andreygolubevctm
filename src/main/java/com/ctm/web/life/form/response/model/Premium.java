package com.ctm.web.life.form.response.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

public class Premium {

    @JsonProperty("insurer_contact")
    private String insurerContact;

    @JsonProperty("product_id")
    private String productId;

    private String name;
    private String companyName;

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

    @JsonProperty("lead_number")
    private String leadNumber;
    private Features features;

    @JsonProperty("special_offer")
    private String special_offer;

    @JsonProperty("call_centre_hours")
    private String callCentreHours;
    private String fsg;

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

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getLeadNumber() {
        return leadNumber;
    }

    public Features getFeatures() {
        return features;
    }

    public String getSpecialOffer() {
        return special_offer;
    }

    public String getCallCentreHours() {
        return callCentreHours;
    }

    public String getFsg() {
        return fsg;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Premium premium = (Premium) o;

        if (insurerContact != null ? !insurerContact.equals(premium.insurerContact) : premium.insurerContact != null)
            return false;
        if (productId != null ? !productId.equals(premium.productId) : premium.productId != null) return false;
        if (name != null ? !name.equals(premium.name) : premium.name != null) return false;
        if (description != null ? !description.equals(premium.description) : premium.description != null) return false;
        if (belowMinimum != null ? !belowMinimum.equals(premium.belowMinimum) : premium.belowMinimum != null)
            return false;
        if (company != null ? !company.equals(premium.company) : premium.company != null) return false;
        if (serviceProvider != null ? !serviceProvider.equals(premium.serviceProvider) : premium.serviceProvider != null)
            return false;
        if (stars != null ? !stars.equals(premium.stars) : premium.stars != null) return false;
        if (value != null ? !value.equals(premium.value) : premium.value != null) return false;
        return pds != null ? pds.equals(premium.pds) : premium.pds == null && (info != null ? info.equals(premium.info) : premium.info == null);

    }

    @Override
    public int hashCode() {
        int result = insurerContact != null ? insurerContact.hashCode() : 0;
        result = 31 * result + (productId != null ? productId.hashCode() : 0);
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        result = 31 * result + (belowMinimum != null ? belowMinimum.hashCode() : 0);
        result = 31 * result + (company != null ? company.hashCode() : 0);
        result = 31 * result + (serviceProvider != null ? serviceProvider.hashCode() : 0);
        result = 31 * result + (stars != null ? stars.hashCode() : 0);
        result = 31 * result + (value != null ? value.hashCode() : 0);
        result = 31 * result + (pds != null ? pds.hashCode() : 0);
        result = 31 * result + (info != null ? info.hashCode() : 0);
        return result;
    }

    public void setLeadNumber(String leadNumber) {
        this.leadNumber = leadNumber;
    }

    public void setFeatures(Features features) {
        this.features = features;
    }

    public void setSpecial_offer(String special_offer) {
        this.special_offer = special_offer;
    }

    public void setCallCentreHours(String call_centre_hours) {
        this.callCentreHours = call_centre_hours;
    }

    public void setFsg(String fsg) {
        this.fsg = fsg;
    }
}
