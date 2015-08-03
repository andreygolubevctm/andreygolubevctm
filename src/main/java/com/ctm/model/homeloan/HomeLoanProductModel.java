package com.ctm.model.homeloan;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;


public class HomeLoanProductModel extends AbstractJsonModel {

	private Boolean repaymentsWeekly;
	private Boolean repaymentsFortnightly;
	private Boolean repaymentsMonthly;
	private Boolean redrawFacility;
	private Boolean mortgageOffset;
	private Boolean extraRepayments;
	private Boolean internetBanking;
	private Boolean bpayAccess;



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





	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("weekly", isRepaymentsWeekly());
		json.put("monthly", isRepaymentsMonthly());
		json.put("fortni", isRepaymentsFortnightly());
		json.put("redraw", isRedrawFacility());
		json.put("offset", isMortgageOffset());
		json.put("extra", isExtraRepayments());
		json.put("internet", isInternetBanking());
		json.put("bpay", isBpayAccess());

		return json;
	}
}
