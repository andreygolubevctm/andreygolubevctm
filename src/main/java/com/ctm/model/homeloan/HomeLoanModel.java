package com.ctm.model.homeloan;

import javax.validation.Valid;

public class HomeLoanModel {

	public static enum CustomerSituation {
		FIRST_HOME_BUYER ("F", "A First Home Buyer"),
		EXISTING_HOME_OWNER ("E", "An Existing Home Owner");

		private final String code, description;

		CustomerSituation(String code, String description) {
			this.code = code;
			this.description = description;
		}

		public String getCode() {
			return code;
		}

		public String getDescription() {
			return description;
		}

		/**
		 * Find by its code.
		 * @param code Code e.g. P
		 */
		public static CustomerSituation findByCode(String code) {
			for (CustomerSituation t : CustomerSituation.values()) {
				if (code.equals(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	public static enum CustomerGoal {
		BUY_FIRST_HOME ("FH", "Buy my first home"),
		ANOTHER_PROPERTY_TO_LIVE_IN ("APL", "Buy another property to live in"),
		BUY_INVESTMENT ("IP", "Buy an investment property"),
		RENOVATE_EXISTING ("REP", "Renovate my existing property"),
		COMPARE_LOANS ("CL", "Compare better home loan options"),
		CONSOLIDATE_DEBT ("CD", "Consolidate my debt");

		private final String code, description;

		CustomerGoal(String code, String description) {
			this.code = code;
			this.description = description;
		}

		public String getCode() {
			return code;
		}

		public String getDescription() {
			return description;
		}

		/**
		 * Find by its code.
		 * @param code Code e.g. P
		 */
		public static CustomerGoal findByCode(String code) {
			for (CustomerGoal t : CustomerGoal.values()) {
				if (code.equals(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	public static enum RepaymentOptions {
		PRINCIPAL_AND_INTEREST ("P", "Principal & Interest"),
		INTEREST_ONLY ("I", "Interest Only");

		private final String code, description;

		RepaymentOptions(String code, String description) {
			this.code = code;
			this.description = description;
		}

		public String getCode() {
			return code;
		}

		public String getDescription() {
			return description;
		}

		/**
		 * Find by its code.
		 * @param code Code e.g. P
		 */
		public static RepaymentOptions findByCode(String code) {
			for (RepaymentOptions t : RepaymentOptions.values()) {
				if (code.equals(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	//---------------------------------------------------------------

	// Required
	private int pageNumber = 1;
	private CustomerSituation customerSituation;
	private CustomerGoal customerGoal;
	private String state;
	private int purchasePrice;
	private int loanAmount;
	private RepaymentOptions repaymentOption;
	private int loanTerm;
	private int amountOwingOnLoan;
	private int existingPropertiesWorth;

	// Optional
	// These are class types so they can be nulled (i.e. no value specified)
	private Long transactionId;
	private String productId;
	private Boolean rateVariable;
	private Boolean rateFixed;
	private Boolean lineOfCredit;
	private Boolean introRate;
	private Boolean repaymentsWeekly;
	private Boolean repaymentsFortnightly;
	private Boolean repaymentsMonthly;
	private Boolean noApplicationFees;
	private Boolean noOngoingFees;
	private Boolean redrawFacility;
	private Boolean mortgageOffset;
	private Boolean extraRepayments;
	private Boolean internetBanking;
	private Boolean bpayAccess;
	private String productsMustBeIncluded;
	private Integer depositAmount;
	@Valid
	public HomeLoanContact contact;
	private String emailAddress;
	private String contactPhoneNumber;
	private String contactBestContact;
	private String contactBestTime;
	private String addressCity;
	private String addressPostcode;
	private Boolean foundAProperty;
	private String offerTime;
	private String propertyType;
	private String employmentStatus;
	private String additionalInformation;

	public Long getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(Long transactionId) {
		this.transactionId = transactionId;
	}

	public String getProductId() {
		return productId;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}

	public Integer getDepositAmount() {
		return depositAmount;
	}
	public void setDepositAmount(Integer depositAmount) {
		this.depositAmount = depositAmount;
	}

	public int getPageNumber() {
		return pageNumber;
	}
	public void setPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
	}
	public CustomerSituation getCustomerSituation() {
		return customerSituation;
	}
	/**
	 * Current situation of the customer.
	 * @param customerSituation
	 */
	public void setCustomerSituation(CustomerSituation customerSituation) {
		this.customerSituation = customerSituation;
	}
	public CustomerGoal getCustomerGoal() {
		return customerGoal;
	}
	public void setCustomerGoal(CustomerGoal customerGoal) {
		this.customerGoal = customerGoal;
	}
	public String getState() {
		return state;
	}
	/**
	 * State/territory of Australia.
	 * @param state
	 */
	public void setState(String state) {
		this.state = state;
	}
	public int getPurchasePrice() {
		return purchasePrice;
	}
	public void setPurchasePrice(int purchasePrice) {
		this.purchasePrice = purchasePrice;
	}
	public int getLoanAmount() {
		return loanAmount;
	}
	public void setLoanAmount(int loanAmount) {
		this.loanAmount = loanAmount;
	}
	public RepaymentOptions getRepaymentOption() {
		return repaymentOption;
	}
	public void setRepaymentOption(RepaymentOptions repaymentOption) {
		this.repaymentOption = repaymentOption;
	}
	public int getLoanTerm() {
		return loanTerm;
	}
	/**
	 * The loan term preferred by the user. This is the number of years that the customers intends to pay back the loan in.
	 * @param loanTerm
	 */
	public void setLoanTerm(int loanTerm) {
		this.loanTerm = loanTerm;
	}
	public int getAmountOwingOnLoan() {
		return amountOwingOnLoan;
	}
	public void setAmountOwingOnLoan(int amountOwingOnLoan) {
		this.amountOwingOnLoan = amountOwingOnLoan;
	}
	public int getExistingPropertiesWorth() {
		return existingPropertiesWorth;
	}
	public void setExistingPropertiesWorth(int existingPropertiesWorth) {
		this.existingPropertiesWorth = existingPropertiesWorth;
	}
	public Boolean isRateVariable() {
		return rateVariable;
	}
	public void setRateVariable(Boolean rateVariable) {
		this.rateVariable = rateVariable;
	}
	public Boolean isRateFixed() {
		return rateFixed;
	}
	public void setRateFixed(Boolean rateFixed) {
		this.rateFixed = rateFixed;
	}
	public Boolean isLineOfCredit() {
		return lineOfCredit;
	}
	public void setLineOfCredit(Boolean lineOfCredit) {
		this.lineOfCredit = lineOfCredit;
	}
	public Boolean isIntroRate() {
		return introRate;
	}
	public void setIntroRate(Boolean introRate) {
		this.introRate = introRate;
	}
	public Boolean isRepaymentsWeekly() {
		return repaymentsWeekly;
	}
	public void setRepaymentsWeekly(Boolean repaymentsWeekly) {
		this.repaymentsWeekly = repaymentsWeekly;
	}
	public Boolean isRepaymentsFortnightly() {
		return repaymentsFortnightly;
	}
	public void setRepaymentsFortnightly(Boolean repaymentsFortnightly) {
		this.repaymentsFortnightly = repaymentsFortnightly;
	}
	public Boolean isRepaymentsMonthly() {
		return repaymentsMonthly;
	}
	public void setRepaymentsMonthly(Boolean repaymentsMonthly) {
		this.repaymentsMonthly = repaymentsMonthly;
	}
	public Boolean isNoApplicationFees() {
		return noApplicationFees;
	}
	public void setNoApplicationFees(Boolean noApplicationFees) {
		this.noApplicationFees = noApplicationFees;
	}
	public Boolean isNoOngoingFees() {
		return noOngoingFees;
	}
	public void setNoOngoingFees(Boolean noOngoingFees) {
		this.noOngoingFees = noOngoingFees;
	}
	public Boolean isRedrawFacility() {
		return redrawFacility;
	}
	public void setRedrawFacility(Boolean redrawFacility) {
		this.redrawFacility = redrawFacility;
	}
	public Boolean isMortgageOffset() {
		return mortgageOffset;
	}
	public void setMortgageOffset(Boolean mortgageOffset) {
		this.mortgageOffset = mortgageOffset;
	}
	public Boolean isExtraRepayments() {
		return extraRepayments;
	}
	public void setExtraRepayments(Boolean extraRepayments) {
		this.extraRepayments = extraRepayments;
	}
	public Boolean isInternetBanking() {
		return internetBanking;
	}
	public void setInternetBanking(Boolean internetBanking) {
		this.internetBanking = internetBanking;
	}
	public Boolean isBpayAccess() {
		return bpayAccess;
	}
	public void setBpayAccess(Boolean bpayAccess) {
		this.bpayAccess = bpayAccess;
	}

	public String getProductsMustBeIncluded() {
		return productsMustBeIncluded;
	}
	/**
	 * The products that must be included as part of a search result.
	 * Used typically when a user has selected a few products and has refreshed the search spec.
	 * @param productsMustBeIncluded Comma separated string of flex products that must be included in a result set. E.g. "1-xxxx, 1-yyyyy"
	 */
	public void setProductsMustBeIncluded(String productsMustBeIncluded) {
		this.productsMustBeIncluded = productsMustBeIncluded;
	}

	public String getContactFirstName() {
		return contact.firstName;
	}
	public String getContactSurname() {
		return contact.lastName;
	}
	public String getEmailAddress() {
		return emailAddress;
	}
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}
	public String getContactPhoneNumber() {
		return contactPhoneNumber;
	}
	public void setContactPhoneNumber(String contactPhoneNumber) {
		this.contactPhoneNumber = contactPhoneNumber;
	}
	public String getContactBestContact() {
		return contactBestContact;
	}
	public void setContactBestContact(String contactBestContact) {
		this.contactBestContact = contactBestContact;
	}

	public String getContactBestTime() {
		return contactBestTime;
	}
	public void setContactBestTime(String contactBestTime) {
		this.contactBestTime = contactBestTime;
	}
	public String getAddressCity() {
		return addressCity;
	}
	public void setAddressCity(String addressCity) {
		this.addressCity = addressCity;
	}
	public String getAddressPostcode() {
		return addressPostcode;
	}
	public void setAddressPostcode(String addressPostcode) {
		this.addressPostcode = addressPostcode;
	}

	public Boolean getFoundAProperty() {
		return foundAProperty;
	}
	public void setFoundAProperty(Boolean foundAProperty) {
		this.foundAProperty = foundAProperty;
	}

	public String getOfferTime() {
		return offerTime;
	}
	public void setOfferTime(String offerTime) {
		this.offerTime = offerTime;
	}

	public String getPropertyType() {
		return propertyType;
	}
	public void setPropertyType(String propertyType) {
		this.propertyType = propertyType;
	}

	public String getEmploymentStatus() {
		return employmentStatus;
	}
	public void setEmploymentStatus(String employmentStatus) {
		this.employmentStatus = employmentStatus;
	}

	public String getAdditionalInformation() {
		return additionalInformation;
	}
	public void setAdditionalInformation(String additionalInformation) {
		this.additionalInformation = additionalInformation;
	}
}
