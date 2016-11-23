package com.ctm.web.health.email.model;


import com.ctm.web.core.email.model.EmailModel;

import java.util.Optional;

public class HealthProductBrochuresEmailModel extends EmailModel {

	private String brand;
	private long transactionId;
	private String firstName;
	private String lastName;
	private String callcentreHours;
	private String productName;
	private boolean optIn;
	private String phoneNumber;
	private String premium;
	private String premiumFrequency;
	private String premiumText;
	private String provider;
	private String smallLogo;
	private String hospitalPDSUrl;
	private String extrasPDSUrl;
	private String applyUrl;

	private String healthSituation;
	private String primaryCurrentPHI;
	private String coverType;
	private String benefitCodes;
	private String specialOffer;
	private String specialOfferTerms;
	private String excessPerAdmission;
	private String excessPerPerson;
	private String excessPerPolicy;
	private String coPayment;

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getCallcentreHours() {
		return callcentreHours;
	}

	public void setCallcentreHours(String callcentreHours) {
		this.callcentreHours = callcentreHours;
	}

	public boolean getOptIn() {
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

	public String getPremium() {
		return premium;
	}

	public void setPremium(String premium) {
		this.premium = premium;
	}

	public String getPremiumFrequency() {
		return premiumFrequency;
	}

	public void setPremiumFrequency(String premiumFrequency) {
		this.premiumFrequency = premiumFrequency;
	}

	public String getPremiumText() {
		return premiumText;
	}

	public void setPremiumText(String premiumText) {
		this.premiumText = premiumText;
	}

	public String getProvider() {
		return provider;
	}

	public void setProvider(String provider) {
		this.provider = provider;
	}

	public String getSmallLogo() {
		return smallLogo;
	}

	public void setSmallLogo(String smallLogo) {
		this.smallLogo = smallLogo;
	}

	public String getHospitalPDSUrl() {
		return hospitalPDSUrl;
	}

	public void setHospitalPDSUrl(String hospitalPDSUrl) {
		this.hospitalPDSUrl = hospitalPDSUrl;
	}

	public String getExtrasPDSUrl() {
		return extrasPDSUrl;
	}

	public void setExtrasPDSUrl(String extrasPDSUrl) {
		this.extrasPDSUrl = extrasPDSUrl;
	}

	public long getTransactionId() {
		return transactionId;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setApplyUrl(String applyUrl) {
		this.applyUrl = applyUrl;
	}

	public String getApplyURL() {
		return applyUrl;
	}

	public boolean isOptIn() {
		return optIn;
	}

	public String getApplyUrl() {
		return applyUrl;
	}

	public Optional<String> getHealthSituation() {
		return Optional.ofNullable(healthSituation);
	}

	public void setHealthSituation(String healthSituation) {
		this.healthSituation = healthSituation;
	}

	public Optional<String> getPrimaryCurrentPHI() {
		return Optional.ofNullable(primaryCurrentPHI);
	}

	public void setPrimaryCurrentPHI(String primaryCurrentPHI) {
		this.primaryCurrentPHI = primaryCurrentPHI;
	}

	public Optional<String> getCoverType() {
		return Optional.ofNullable(coverType);
	}

	public void setCoverType(String coverType) {
		this.coverType = coverType;
	}

	public Optional<String> getBenefitCodes() {
		return Optional.ofNullable(benefitCodes);
	}

	public void setBenefitCodes(String benefitCodes) {
		this.benefitCodes = benefitCodes;
	}

	public Optional<String> getSpecialOffer() {
		return Optional.ofNullable(specialOffer);
	}

	public void setSpecialOffer(String specialOffer) {
		this.specialOffer = specialOffer;
	}

	public Optional<String> getSpecialOfferTerms() {
		return Optional.ofNullable(specialOfferTerms);
	}

	public void setSpecialOfferTerms(String specialOfferTerms) {
		this.specialOfferTerms = specialOfferTerms;
	}

	public Optional<String> getExcessPerAdmission() {
		return Optional.ofNullable(excessPerAdmission);
	}

	public void setExcessPerAdmission(String excessPerAdmission) {
		this.excessPerAdmission = excessPerAdmission;
	}

	public Optional<String> getExcessPerPerson() {
		return Optional.ofNullable(excessPerPerson);
	}

	public void setExcessPerPerson(String excessPerPerson) {
		this.excessPerPerson = excessPerPerson;
	}

	public Optional<String> getExcessPerPolicy() {
		return Optional.ofNullable(excessPerPolicy);
	}

	public void setExcessPerPolicy(String excessPerPolicy) {
		this.excessPerPolicy = excessPerPolicy;
	}

	public Optional<String> getCoPayment() {
		return Optional.ofNullable(coPayment);
	}

	public void setCoPayment(String coPayment) {
		this.coPayment = coPayment;
	}

	@Override
	public void setEmailAddress(String emailAddress) {
		super.setEmailAddress(emailAddress);
		setSubscriberKey(emailAddress);
	}

	@Override
	public String toString() {
		return "HealthProductBrochuresEmailModel{" +
				"brand='" + brand + '\'' +
				", transactionId=" + transactionId +
				", firstName='" + firstName + '\'' +
				", lastName='" + lastName + '\'' +
				", callcentreHours='" + callcentreHours + '\'' +
				", productName='" + productName + '\'' +
				", optIn=" + optIn +
				", phoneNumber='" + phoneNumber + '\'' +
				", premium='" + premium + '\'' +
				", premiumFrequency='" + premiumFrequency + '\'' +
				", premiumText='" + premiumText + '\'' +
				", provider='" + provider + '\'' +
				", smallLogo='" + smallLogo + '\'' +
				", hospitalPDSUrl='" + hospitalPDSUrl + '\'' +
				", extrasPDSUrl='" + extrasPDSUrl + '\'' +
				", applyUrl='" + applyUrl + '\'' +
				", healthSituation='" + healthSituation + '\'' +
				", primaryCurrentPHI='" + primaryCurrentPHI + '\'' +
				", coverType='" + coverType + '\'' +
				", benefitCodes='" + benefitCodes + '\'' +
				", specialOffer='" + specialOffer + '\'' +
				", specialOfferTerms='" + specialOfferTerms + '\'' +
				", excessPerAdmission='" + excessPerAdmission + '\'' +
				", excessPerPerson='" + excessPerPerson + '\'' +
				", excessPerPolicy='" + excessPerPolicy + '\'' +
				", coPayment='" + coPayment + '\'' +
				'}';
	}
}
