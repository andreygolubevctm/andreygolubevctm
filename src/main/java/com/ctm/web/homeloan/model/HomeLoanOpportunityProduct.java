package com.ctm.web.homeloan.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;
import com.ctm.web.homeloan.model.HomeLoanModel.RepaymentOptions;

public class HomeLoanOpportunityProduct extends AbstractJsonModel {

	private String flexId;
	private String loanPurpose = "Regulated";
	private RepaymentOptions repaymentOption;
	private Boolean selected;
	private String integrationId;



	public String getFlexId() {
		return flexId;
	}
	public void setFlexId(String flexId) {
		this.flexId = flexId;
	}

	public String getLoanPurpose() {
		return loanPurpose;
	}
	public void setLoanPurpose(String loanPurpose) {
		this.loanPurpose = loanPurpose;
	}

	public RepaymentOptions getRepaymentOption() {
		return repaymentOption;
	}
	public void setRepaymentOption(RepaymentOptions repaymentOption) {
		this.repaymentOption = repaymentOption;
	}

	public Boolean getSelected() {
		return selected;
	}
	/**
	 * Flag to indicate the product the customer is enquiring about
	 */
	public void setSelected(Boolean selected) {
		this.selected = selected;
	}

	public String getIntegrationId() {
		return integrationId;
	}
	/**
	 * Random generated string of 15 characters. Must be unique per request.
	 */
	public void setIntegrationId(String integrationId) {
		this.integrationId = integrationId;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("flexId", getFlexId());
		json.put("loanPurpose", getLoanPurpose());
		if (getRepaymentOption() != null) {
			json.put("repaymentOption", getRepaymentOption().getDescription());
		}
		json.put("selected", getSelected());
		json.put("integrationId", getIntegrationId());

		return json;
	}

}
