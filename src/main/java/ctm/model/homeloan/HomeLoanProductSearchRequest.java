package com.ctm.model.homeloan;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;


public class HomeLoanProductSearchRequest extends AbstractJsonModel {

	private HomeLoanModel model;



	public HomeLoanModel getModel() {
		return model;
	}
	public void setModel(HomeLoanModel model) {
		this.model = model;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		// As per AFG doc, pageNum is type string
		json.put("pageNum", Integer.toString(model.getPageNumber()));

		if (model.getCustomerSituation() != null) {
			json.put("iAm", model.getCustomerSituation().getDescription());
		}
		if (model.getCustomerGoal() != null) {
			json.put("lookingTo", model.getCustomerGoal().getDescription());
		}
		json.put("state", model.getState());
		json.put("amountOwingOnLoan", model.getAmountOwingOnLoan());
		json.put("existingPropertiesWorth", model.getExistingPropertiesWorth());
		json.put("purchasePrice", model.getPurchasePrice());
		json.put("loanAmount", model.getLoanAmount());
		json.put("variable", model.isRateVariable());
		json.put("fixed", model.isRateFixed());
		json.put("lineOfCredit", model.isLineOfCredit());
		json.put("introRate", model.isIntroRate());
		if (model.getRepaymentOption() != null) {
			json.put("repaymentOption", model.getRepaymentOption().getDescription());
		}
		json.put("loanTerm", model.getLoanTerm());
		json.put("repaymentsWeekly", model.isRepaymentsWeekly());
		json.put("repaymentsMonthly", model.isRepaymentsMonthly());
		json.put("repaymentsFortnightly", model.isRepaymentsFortnightly());
		json.put("noApplicationFees", model.isNoApplicationFees());
		json.put("noOngoingFees", model.isNoOngoingFees());
		json.put("redrawFacility", model.isRedrawFacility());
		json.put("mortgageOffset", model.isMortgageOffset());
		json.put("extraRepayments", model.isExtraRepayments());
		json.put("internetBanking", model.isInternetBanking());
		json.put("bpayAccess", model.isBpayAccess());
		json.put("productsMustBeIncluded", model.getProductsMustBeIncluded());

		return json;
	}
}
