package com.ctm.web.simples.admin.model;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

public class SpecialOffers {
	 
	public int offerId;
	
	@Range(min=1, message="Provider ID must be positive Integer")	
	public int providerId;
	
	@NotEmpty(message="Terms and Conditions can not be empty")
	public String terms;
	
	@NotEmpty(message="Description can not be empty")
	@Length(max=1000, message="Number of letters for the description must be less than 1000")
	public String content;
	
	@NotEmpty(message="Effective Start date can not be empty")
	public String effectiveStart;
	
	@NotEmpty(message="Effective End date  can not be empty")
	public String effectiveEnd;

	@Range(min=0, message="StyleCode ID must be a positive Integer")
	public int styleCodeId;

	public String styleCode;

	@NotEmpty(message="Please provide a state")
	public String state;

    @NotEmpty(message="Please provide a coverType")
    public String coverType;

	public String providerName;

	public String offerType;

	public SpecialOffers(){

	}
	
	public int getOfferId() {
		return offerId;
	}

	public void setOfferId(int offerId) {
		this.offerId = offerId;
	}

	public int getProviderId() {
		return providerId;
	}

	public void setProviderId(int providerId) {
		this.providerId = providerId;
	}

	public String getTerms() {
		return terms;
	}

	public void setTerms(String terms) {
		this.terms = terms;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getEffectiveStart() {
		return effectiveStart;
	}
	public void setEffectiveStart(String effectiveStart) {
		this.effectiveStart = effectiveStart;
	}
	public String getEffectiveEnd() {
		return effectiveEnd;
	}
	public void setEffectiveEnd(String effectiveEnd) {
		this.effectiveEnd = effectiveEnd;
	}


	public int getStyleCodeId() {
		return styleCodeId;
	}

	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state!=null?state.toUpperCase():"0";
	}

    public String getCoverType() {
        return coverType;
    }

    public void setCoverType(String coverType) {
        this.coverType = coverType!=null?coverType.toUpperCase():"0";
    }

	public String getStyleCode() {
		return styleCode;
	}

	public void setStyleCode(String styleCode) {
		this.styleCode = styleCode;
	}

	public String getProviderName() {
		return providerName;
	}

	public void setProviderName(String providerName) {
		this.providerName = providerName;
	}

	public String getOfferType() {
		return offerType;
	}

	public void setOfferType(String offerType) {
		this.offerType = offerType;
	}
}
