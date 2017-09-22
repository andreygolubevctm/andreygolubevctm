package com.ctm.web.email;

import com.ctm.web.email.health.HealthEmailModel;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import io.swagger.annotations.ApiModel;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Created by akhurana on 8/09/17.
 */
public class EmailRequest {
    private String partnersQuoted;
    private String prospectID;
    private List<String> coverTypes;
    private List<String> provider;
    private List<String> premiumLabel;
    private OptIn optIn;
    private List<String> providerPhoneNumber;
    private String callCentreHours;
    private String callCentreHoursText;
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    private LocalDateTime commencementDate;
    private List<String> applyUrl;
    private String emailAddress;
    private String brand;
    private List<String> premium;
    private List<String> quoteRef;
    private String lastName;
    private String subscriberKey;
    private String firstName;
    private String premiumFrequency;
    private String transactionId;
    private String address;
    private String phoneNumber;
    private List<String> providerCode;
    private String unsubscribeURL;
    private String GaClientID;
    private List<String> providerSpecialOffer;

    private HealthEmailModel healthEmailModel;

    public HealthEmailModel getHealthEmailModel() {
        return healthEmailModel;
    }

    public void setHealthEmailModel(HealthEmailModel healthEmailModel) {
        this.healthEmailModel = healthEmailModel;
    }

    public String getPartnersQuoted() {
        return partnersQuoted;
    }

    public void setPartnersQuoted(String partnersQuoted) {
        this.partnersQuoted = partnersQuoted;
    }

    public String getProspectID() {
        return prospectID;
    }

    public void setProspectID(String prospectID) {
        this.prospectID = prospectID;
    }

    public List<String> getCoverTypes() {
        return coverTypes;
    }

    public void setCoverTypes(List<String> coverTypes) {
        this.coverTypes = coverTypes;
    }

    public List<String> getProvider() {
        return provider;
    }

    public void setProvider(List<String> provider) {
        this.provider = provider;
    }

    public List<String> getPremiumLabel() {
        return premiumLabel;
    }

    public void setPremiumLabel(List<String> premiumLabel) {
        this.premiumLabel = premiumLabel;
    }

    public OptIn getOptIn() {
        return optIn;
    }

    public void setOptIn(OptIn optIn) {
        this.optIn = optIn;
    }

    public List<String> getProviderPhoneNumber() {
        return providerPhoneNumber;
    }

    public void setProviderPhoneNumber(List<String> providerPhoneNumber) {
        this.providerPhoneNumber = providerPhoneNumber;
    }

    public String getCallCentreHours() {
        return callCentreHours;
    }

    public void setCallCentreHours(String callCentreHours) {
        this.callCentreHours = callCentreHours;
    }

    public String getCallCentreHoursText() {
        return callCentreHoursText;
    }

    public void setCallCentreHoursText(String callCentreHoursText) {
        this.callCentreHoursText = callCentreHoursText;
    }

    public LocalDateTime getCommencementDate() {
        return commencementDate;
    }

    public void setCommencementDate(LocalDateTime commencementDate) {
        this.commencementDate = commencementDate;
    }

    public List<String> getApplyUrl() {
        return applyUrl;
    }

    public void setApplyUrl(List<String> applyUrl) {
        this.applyUrl = applyUrl;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public List<String> getPremium() {
        return premium;
    }

    public void setPremium(List<String> premium) {
        this.premium = premium;
    }

    public List<String> getQuoteRef() {
        return quoteRef;
    }

    public void setQuoteRef(List<String> quoteRef) {
        this.quoteRef = quoteRef;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getSubscriberKey() {
        return subscriberKey;
    }

    public void setSubscriberKey(String subscriberKey) {
        this.subscriberKey = subscriberKey;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getPremiumFrequency() {
        return premiumFrequency;
    }

    public void setPremiumFrequency(String premiumFrequency) {
        this.premiumFrequency = premiumFrequency;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public List<String> getProviderCode() {
        return providerCode;
    }

    public void setProviderCode(List<String> providerCode) {
        this.providerCode = providerCode;
    }

    public String getUnsubscribeURL() {
        return unsubscribeURL;
    }

    public void setUnsubscribeURL(String unsubscribeURL) {
        this.unsubscribeURL = unsubscribeURL;
    }

    public String getGaClientID() {
        return GaClientID;
    }

    public void setGaClientID(String gaClientID) {
        GaClientID = gaClientID;
    }

    public List<String> getProviderSpecialOffer() {
        return providerSpecialOffer;
    }

    public void setProviderSpecialOffer(List<String> providerSpecialOffer) {
        this.providerSpecialOffer = providerSpecialOffer;
    }

}
