package com.ctm.model.coupon;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

/**
 * This model represents the ctm.conpons database table.
 *
 */
public class Coupon extends AbstractJsonModel {

	private int couponId;
	private int styleCodeId;
	private int verticalId;
	private String couponCode;
	private boolean isExclusive;
	private boolean showPopup;
	private boolean canPrePopulate;
	private String contentBanner;
	private String contentSuccess;
	private String contentCheckbox;
	private String contentConfirmation;
	private Date effectiveStart;
	private Date effectiveEnd;
	private CouponChannel couponChannel;
	private boolean removeFromLeads;
	private int vdn;
	private List<CouponRule> couponRules;

	public int getCouponId() {
		return couponId;
	}
	public void setCouponId(int couponId) {
		this.couponId = couponId;
	}
	public int getStyleCodeId() {
		return styleCodeId;
	}
	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}
	public int getVerticalId() {
		return verticalId;
	}
	public void setVerticalId(int verticalId) {
		this.verticalId = verticalId;
	}
	public String getCouponCode() {
		return couponCode;
	}
	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}
	public boolean isExclusive() {
		return isExclusive;
	}
	public void setExclusive(boolean isExclusive) {
		this.isExclusive = isExclusive;
	}
	public boolean isShowPopup() {
		return showPopup;
	}
	public void setShowPopup(boolean showPopup) {
		this.showPopup = showPopup;
	}
	public boolean canPrePopulate() {
		return canPrePopulate;
	}
	public void setPrePopulate(boolean canPrePopulate) {
		this.canPrePopulate = canPrePopulate;
	}
	public String getContentBanner() {
		return contentBanner;
	}
	public void setContentBanner(String contentBanner) {
		this.contentBanner = contentBanner;
	}
	public String getContentSuccess() {
		return contentSuccess;
	}
	public void setContentSuccess(String contentSuccess) {
		this.contentSuccess = contentSuccess;
	}
	public String getContentCheckbox() {
		return contentCheckbox;
	}
	public void setContentCheckbox(String contentCheckbox) {
		this.contentCheckbox = contentCheckbox;
	}
	public String getContentConfirmation() {
		return contentConfirmation;
	}
	public void setContentConfirmation(String contentConfirmation) {
		this.contentConfirmation = contentConfirmation;
	}
	public Date getEffectiveStart() {
		return effectiveStart;
	}
	public void setEffectiveStart(Date effectiveStart) {
		this.effectiveStart = effectiveStart;
	}
	public Date getEffectiveEnd() {
		return effectiveEnd;
	}
	public void setEffectiveEnd(Date effectiveEnd) {
		this.effectiveEnd = effectiveEnd;
	}
	public CouponChannel getCouponChannel() {
		return couponChannel;
	}
	public void setCouponChannel(CouponChannel couponChannel) {
		this.couponChannel = couponChannel;
	}
	public void setCouponChannel(String couponChannelString) {
		this.couponChannel = CouponChannel.findByCode(couponChannelString);
	}
	public boolean isRemoveFromLeads() {
		return removeFromLeads;
	}
	public void setRemoveFromLeads(boolean removeFromLeads) {
		this.removeFromLeads = removeFromLeads;
	}
	public int getVdn() {
		return vdn;
	}
	public void setVdn(int vdn) {
		this.vdn = vdn;
	}
	public List<CouponRule> getCouponRules() {
		if (couponRules == null) {
			couponRules = new ArrayList<CouponRule>();
		}
		return couponRules;
	}
	public void setCouponRules(List<CouponRule> couponRules) {
		this.couponRules = couponRules;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("couponId", getCouponId());
		json.put("couponCode", getCouponCode());
		json.put("contentBanner", getContentBanner());
		json.put("contentSuccess", getContentSuccess());
		json.put("contentCheckbox", getContentCheckbox());
		json.put("contentConfirmation", getContentConfirmation());
		json.put("showPopup", isShowPopup());
		json.put("canPrePopulate", canPrePopulate());

		return json;
	}

	@Override
	public String toString() {
		return "Coupon{" +
				"couponId=" + couponId +
				", styleCodeId=" + styleCodeId +
				", verticalId=" + verticalId +
				", couponCode='" + couponCode + '\'' +
				", isExclusive=" + isExclusive +
				", showPopup=" + showPopup +
				", canPrePopulate=" + canPrePopulate +
				", contentBanner='" + contentBanner + '\'' +
				", contentSuccess='" + contentSuccess + '\'' +
				", contentCheckbox='" + contentCheckbox + '\'' +
				", contentConfirmation='" + contentConfirmation + '\'' +
				", effectiveStart=" + effectiveStart +
				", effectiveEnd=" + effectiveEnd +
				", couponChannel=" + couponChannel +
				", removeFromLeads=" + removeFromLeads +
				", vdn=" + vdn +
				", couponRules=" + couponRules +
				'}';
	}
}