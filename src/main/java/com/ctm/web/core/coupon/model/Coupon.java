package com.ctm.web.core.coupon.model;

import com.ctm.web.core.model.AbstractJsonModel;
import com.fasterxml.jackson.annotation.JsonView;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * This model represents the ctm.coupons database table.
 */
public class Coupon extends AbstractJsonModel {

	private int couponId;
	private int styleCodeId;
	private int verticalId;
	private String campaignName;
	@JsonView(Views.ForWordpressSite.class)
	private String couponCode;
	private double couponValue;
	private boolean isExclusive;
	private boolean showPopup;
	private boolean canPrePopulate;
    private String contentTile;
	private String contentBanner;
	private String contentSuccess;
	private String contentCheckbox;
	private String contentConfirmation;
	@JsonView(Views.ForWordpressSite.class)
	private String contentWordpress;
	private Date effectiveStart;
	private Date effectiveEnd;
	private CouponChannel couponChannel;
	private CouponOpenHoursCondition openHoursCond;
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
	public String getCampaignName() {
		return campaignName;
	}
	public void setCampaignName(String campaignName) {
		this.campaignName = campaignName;
	}
	public String getCouponCode() {
		return couponCode;
	}
	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}
	public double getCouponValue() {
		return couponValue;
	}
	public void setCouponValue(double couponValue) {
		this.couponValue = couponValue;
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
    public String getContentTile() {
        return contentTile;
    }
    public void setContentTile(String contentTile) {
        this.contentTile = contentTile;
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
	public String getContentWordpress() {
		return contentWordpress;
	}
	public void setContentWordpress(String contentWordpress) {
		this.contentWordpress = contentWordpress;
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
	public CouponOpenHoursCondition getOpenHoursCond() {
		return openHoursCond;
	}
	public void setOpenHoursCond(CouponOpenHoursCondition openHoursCond) {
		this.openHoursCond = openHoursCond;
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
			couponRules = new ArrayList<>();
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
		json.put("campaignName", getCampaignName());
		json.put("couponCode", getCouponCode());
		json.put("couponValue", getCouponValue());
        json.put("contentTile", getContentTile());
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
				", campaignName=" + campaignName + '\'' +
				", couponCode='" + couponCode + '\'' +
				", couponValue=" + couponValue +
				", isExclusive=" + isExclusive +
				", showPopup=" + showPopup +
				", canPrePopulate=" + canPrePopulate +
				", contentTile='" + contentTile + '\'' +
				", contentBanner='" + contentBanner + '\'' +
				", contentSuccess='" + contentSuccess + '\'' +
				", contentCheckbox='" + contentCheckbox + '\'' +
				", contentConfirmation='" + contentConfirmation + '\'' +
				", contentWordpress='" + contentWordpress + '\'' +
				", effectiveStart=" + effectiveStart +
				", effectiveEnd=" + effectiveEnd +
				", couponChannel=" + couponChannel +
				", openHoursCond=" + openHoursCond +
				", removeFromLeads=" + removeFromLeads +
				", vdn=" + vdn +
				", couponRules=" + couponRules +
				'}';
	}
}