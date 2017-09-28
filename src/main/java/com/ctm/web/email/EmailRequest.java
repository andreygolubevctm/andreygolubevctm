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
    private String address;
    private List<String> applyUrls;
    private String brand;
    private String callCentreHours;
    private String callCentreHoursText;
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    private LocalDateTime commencementDate;
    private String coverType;
    private String emailAddress;
    private OptIn optIn;
    private String firstName;
    private String gaClientID;
    private String lastName;
    private Integer partnersQuoted;
    private String phoneNumber;
    private String premiumFrequency;
    private List<String> premiumLabels;
    private List<String> premiums;
    private List<String> providerCodes;
    private List<String> providerPhoneNumbers;
    private List<String> providerSpecialOffers;
    private String prospectID;
    private List<String> providers;
    private List<String> quoteRefs;
    private String subscriberKey;
    private String transactionId;
    private String unsubscribeURL;
    private String vertical;

    private HealthEmailModel healthEmailModel;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public List<String> getApplyUrls() {
        return applyUrls;
    }

    public void setApplyUrls(List<String> applyUrls) {
        this.applyUrls = applyUrls;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
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

    public String getCoverType() {
        return coverType;
    }

    public void setCoverType(String coverType) {
        this.coverType = coverType;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public OptIn getOptIn() {
        return optIn;
    }

    public void setOptIn(OptIn optIn) {
        this.optIn = optIn;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getGaClientID() {
        return gaClientID;
    }

    public void setGaClientID(String gaClientID) {
        this.gaClientID = gaClientID;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public Integer getPartnersQuoted() {
        return partnersQuoted;
    }

    public void setPartnersQuoted(Integer partnersQuoted) {
        this.partnersQuoted = partnersQuoted;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPremiumFrequency() {
        return premiumFrequency;
    }

    public void setPremiumFrequency(String premiumFrequency) {
        this.premiumFrequency = premiumFrequency;
    }

    public List<String> getPremiumLabels() {
        return premiumLabels;
    }

    public void setPremiumLabels(List<String> premiumLabels) {
        this.premiumLabels = premiumLabels;
    }

    public List<String> getPremiums() {
        return premiums;
    }

    public void setPremiums(List<String> premiums) {
        this.premiums = premiums;
    }

    public List<String> getProviderCodes() {
        return providerCodes;
    }

    public void setProviderCodes(List<String> providerCodes) {
        this.providerCodes = providerCodes;
    }

    public List<String> getProviderPhoneNumbers() {
        return providerPhoneNumbers;
    }

    public void setProviderPhoneNumbers(List<String> providerPhoneNumbers) {
        this.providerPhoneNumbers = providerPhoneNumbers;
    }

    public List<String> getProviderSpecialOffers() {
        return providerSpecialOffers;
    }

    public void setProviderSpecialOffers(List<String> providerSpecialOffers) {
        this.providerSpecialOffers = providerSpecialOffers;
    }

    public String getProspectID() {
        return prospectID;
    }

    public void setProspectID(String prospectID) {
        this.prospectID = prospectID;
    }

    public List<String> getProviders() {
        return providers;
    }

    public void setProviders(List<String> providers) {
        this.providers = providers;
    }

    public List<String> getQuoteRefs() {
        return quoteRefs;
    }

    public void setQuoteRefs(List<String> quoteRefs) {
        this.quoteRefs = quoteRefs;
    }

    public String getSubscriberKey() {
        return subscriberKey;
    }

    public void setSubscriberKey(String subscriberKey) {
        this.subscriberKey = subscriberKey;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getUnsubscribeURL() {
        return unsubscribeURL;
    }

    public void setUnsubscribeURL(String unsubscribeURL) {
        this.unsubscribeURL = unsubscribeURL;
    }

    public HealthEmailModel getHealthEmailModel() {
        return healthEmailModel;
    }

    public void setHealthEmailModel(HealthEmailModel healthEmailModel) {
        this.healthEmailModel = healthEmailModel;
    }
}
