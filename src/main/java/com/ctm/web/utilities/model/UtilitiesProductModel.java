package com.ctm.web.utilities.model;

import com.ctm.model.AbstractJsonModel;
import org.json.JSONException;
import org.json.JSONObject;

import static org.apache.commons.lang3.StringEscapeUtils.unescapeHtml4;

public class UtilitiesProductModel extends AbstractJsonModel {

	// Flags
	private String retailerName;
	private String planName;
	private String planDetails = "";
	private String contractDetails = "";
	private String billingOptions = "";
	private String pricingInformation = "";
	private String paymentDetails = "";
	private String termsUrl = "";
	private String privacyPolicyUrl = "";

	public UtilitiesProductModel(){

	}

	// Getters & setters
	public String getRetailerName() {
		return this.retailerName;
	}
	public void setRetailerName(String retailerName) {
		this.retailerName = retailerName;
	}

	public String getPlanName() {
		return this.planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public String getPlanDetails() {
		return this.planDetails;
	}
	public void setPlanDetails(String planDetails) {
		this.planDetails = planDetails;
	}

	public String getContractDetails() {
		return this.contractDetails;
	}
	public void setContractDetails(String contractDetails) {
		this.contractDetails = contractDetails;
	}

	public String getBillingOptions() {
		return this.billingOptions;
	}
	public void setBillingOptions(String billingOptions) {
		this.billingOptions = billingOptions;
	}

	public String getPricingInformation() {
		return this.pricingInformation;
	}
	public void setPricingInformation(String pricingInformation) {
		this.pricingInformation = pricingInformation;
	}

	public String getPaymentDetails() {
		return this.paymentDetails;
	}
	public void setPaymentDetails(String paymentDetails) {
		this.paymentDetails = paymentDetails;
	}

	public String getTermsUrl() {
		return this.termsUrl;
	}
	public void setTermsUrl(String termsUrl) {
		this.termsUrl = termsUrl;
	}

	public String getPrivacyPolicyUrl() {
		return this.privacyPolicyUrl;
	}
	public void setPrivacyPolicyUrl(String privacyPolicyUrl) {
		this.privacyPolicyUrl = privacyPolicyUrl;
	}

	public Boolean populateFromThoughtWorldJson(JSONObject json){
		try {

			if(!json.isNull("retailer_name")) {
				setRetailerName(json.getString("retailer_name"));
			}

			if(!json.isNull("plan_name")) {
				setPlanName(json.getString("plan_name"));
			}
			if(!json.isNull("plan_details")) {
				setPlanDetails(unescapeHtml4(json.getString("plan_details")));
			}
			if(!json.isNull("contract_details")) {
				setContractDetails(unescapeHtml4(json.getString("contract_details")));
			}
			if(!json.isNull("billing_options")) {
				setBillingOptions(unescapeHtml4(json.getString("billing_options")));
			}
			if(!json.isNull("pricing_information")) {
				setPricingInformation(unescapeHtml4(json.getString("pricing_information")));
			}
			if(!json.isNull("payment_details")) {
				setPaymentDetails(unescapeHtml4(json.getString("payment_details")));
			}
			if(!json.isNull("terms")) {
				setTermsUrl(json.getString("terms"));
			}
			if(!json.isNull("privacy_policy")) {
				setPrivacyPolicyUrl(json.getString("privacy_policy"));
			}

		} catch (JSONException e) {
			return false;
		}

		return true;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("retailerName", getRetailerName());
		json.put("planName", getPlanName());
		json.put("planDetails", getPlanDetails());
		json.put("contractDetails", getContractDetails());
		json.put("billingOptions", getBillingOptions());
		json.put("pricingInformation", getPricingInformation());
		json.put("paymentDetails", getPaymentDetails());
		json.put("termsUrl", getTermsUrl());
		json.put("privacyPolicyUrl", getPrivacyPolicyUrl());

		return json;
	}
}
