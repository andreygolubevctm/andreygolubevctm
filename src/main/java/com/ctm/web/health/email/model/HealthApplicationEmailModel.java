package com.ctm.web.health.email.model;

import com.ctm.web.core.email.model.EmailModel;

import java.util.List;
import java.util.Optional;

public class HealthApplicationEmailModel extends EmailModel {

    private String firstName;

    private String bccEmail;

    private boolean optIn;

    private String okToCall;

    private String phoneNumber;

    private long transactionId;

    private String actionUrl;

    private String unsubscribeURL;

    private String productName;

    private String healthFund;

    private String providerPhoneNumber;

    private String hospitalPdsUrl;

    private String extrasPdsUrl;

    private String premiumFrequency;

    private String providerLogo;

    private String premium;

    private String premiumLabel;

    private String healthMembership;

    private String excess;

    private String healthSituation;

    private String coverType;

    private String premiumTotal;

    private String policyStartDate;

    private String providerEmail;

    private PolicyHolderModel primary;

    private PolicyHolderModel partner;

    private List<PolicyHolderModel> dependants;

    public String getBccEmail() {
        return bccEmail;
    }

    public void setBccEmail(String bccEmail) {
        this.bccEmail = bccEmail;
    }

    public String getOkToCall() {
        return okToCall;
    }

    public void setOkToCall(String okToCall) {
        this.okToCall = okToCall;
    }

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    public String getActionUrl() {
        return actionUrl;
    }

    public void setActionUrl(String actionUrl) {
        this.actionUrl = actionUrl;
    }

    @Override
    public String getUnsubscribeURL() {
        return unsubscribeURL;
    }

    @Override
    public void setUnsubscribeURL(String unsubscribeURL) {
        this.unsubscribeURL = unsubscribeURL;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getHealthFund() {
        return healthFund;
    }

    public void setHealthFund(String healthFund) {
        this.healthFund = healthFund;
    }

    public String getProviderPhoneNumber() {
        return providerPhoneNumber;
    }

    public void setProviderPhoneNumber(String providerPhoneNumber) {
        this.providerPhoneNumber = providerPhoneNumber;
    }

    public String getHospitalPdsUrl() {
        return hospitalPdsUrl;
    }

    public void setHospitalPdsUrl(String hospitalPdsUrl) {
        this.hospitalPdsUrl = hospitalPdsUrl;
    }

    public String getExtrasPdsUrl() {
        return extrasPdsUrl;
    }

    public void setExtrasPdsUrl(String extrasPdsUrl) {
        this.extrasPdsUrl = extrasPdsUrl;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public boolean isOptIn() {
        return optIn;
    }

    public void setOptIn(boolean optIn) {
        this.optIn = optIn;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }



    // ---------------------------------------------------------------------


    public Optional<String> getPremiumFrequency() {
        return Optional.ofNullable(premiumFrequency);
    }

    public void setPremiumFrequency(String premiumFrequency) {
        this.premiumFrequency = premiumFrequency;
    }

    public Optional<String> getProviderLogo() {
        return Optional.ofNullable(providerLogo);
    }

    public void setProviderLogo(String providerLogo) {
        this.providerLogo = providerLogo;
    }

    public Optional<String> getPremium() {
        return Optional.ofNullable(premium);
    }

    public void setPremium(String premium) {
        this.premium = premium;
    }

    public Optional<String> getPremiumLabel() {
        return Optional.ofNullable(premiumLabel);
    }

    public void setPremiumLabel(String premiumLabel) {
        this.premiumLabel = premiumLabel;
    }

    public Optional<String> getHealthMembership() {
        return Optional.ofNullable(healthMembership);
    }

    public void setHealthMembership(String healthMembership) {
        this.healthMembership = healthMembership;
    }

    public Optional<String> getExcess() {
        return Optional.ofNullable(excess);
    }

    public void setExcess(String excess) {
        this.excess = excess;
    }

    public Optional<String> getHealthSituation() {
        return Optional.ofNullable(healthSituation);
    }

    public void setHealthSituation(String healthSituation) {
        this.healthSituation = healthSituation;
    }

    public Optional<String> getCoverType() {
        return Optional.ofNullable(coverType);
    }

    public void setCoverType(String coverType) {
        this.coverType = coverType;
    }

    public Optional<String> getPremiumTotal() {
        return Optional.ofNullable(premiumTotal);
    }

    public void setPremiumTotal(String premiumTotal) {
        this.premiumTotal = premiumTotal;
    }

    public Optional<String> getPolicyStartDate() {
        return Optional.ofNullable(policyStartDate);
    }

    public void setPolicyStartDate(String policyStartDate) {
        this.policyStartDate = policyStartDate;
    }

    public Optional<String> getProviderEmail() {
        return Optional.ofNullable(providerEmail);
    }

    public void setProviderEmail(String providerEmail) {
        this.providerEmail = providerEmail;
    }

    public Optional<PolicyHolderModel> getPrimary() {
        return Optional.ofNullable(primary);
    }

    public void setPrimary(PolicyHolderModel primary) {
        this.primary = primary;
    }

    public Optional<PolicyHolderModel> getPartner() {
        return Optional.ofNullable(partner);
    }

    public void setPartner(PolicyHolderModel partner) {
        this.partner = partner;
    }

    public List<PolicyHolderModel> getDependants() {
        return dependants;
    }

    public void setDependants(List<PolicyHolderModel> dependants) {
        this.dependants = dependants;
    }
}
