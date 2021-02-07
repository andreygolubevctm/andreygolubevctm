package com.ctm.web.core.coupon.model;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Test;

public class CouponTest {

    @Test
    public void testCouponJSONObject() throws JSONException {
        Coupon coupon = new Coupon();
        coupon.setCouponId(101);
        coupon.setCouponCode("test-coupon-code");
        coupon.setCampaignName("test-campaign");
        coupon.setCouponValue(1);
        coupon.setContentTile("test content");
        coupon.setContentBanner("All is well");
        coupon.setContentSuccess("go team go");
        coupon.setTermsAndConditions("Nothing in specific");
        coupon.setContentCheckbox("Yes");
        coupon.setContentConfirmation("Yes");
        coupon.setShowPopup(true);
        coupon.setPrePopulate(true);
        coupon.setShowCouponSeen(true);
        JSONObject jsonObject = coupon.getJsonObject();
        Assert.assertNotNull(jsonObject);
        Assert.assertEquals("test-coupon-code", jsonObject.get("couponCode"));
        Assert.assertEquals("Nothing in specific", jsonObject.get("termsAndConditions"));
    }

    @Test
    public void testCouponString() throws Exception {
        Coupon coupon = new Coupon();
        coupon.setCouponId(101);
        coupon.setCouponCode("test-coupon-code");
        coupon.setCampaignName("test-campaign");
        coupon.setCouponValue(1);
        coupon.setContentTile("test content");
        coupon.setContentBanner("All is well");
        coupon.setContentSuccess("go team go");
        coupon.setTermsAndConditions("Nothing in specific");
        coupon.setContentCheckbox("Yes");
        coupon.setContentConfirmation("Yes");
        coupon.setShowPopup(true);
        coupon.setPrePopulate(true);
        coupon.setShowCouponSeen(true);
        String json = coupon.toString();
        Assert.assertEquals("Coupon{couponId=101, styleCodeId=0, verticalId=0, campaignName=test-campaign', couponCode='test-coupon-code', couponValue=1.0, isExclusive=false, showPopup=true, canPrePopulate=true, showCouponSeen=true, contentTile='test content', contentBanner='All is well', contentSuccess='go team go', termsAndConditions='Nothing in specific', contentCheckbox='Yes', contentConfirmation='Yes', contentWordpress='null', effectiveStart=null, effectiveEnd=null, couponChannel=null, openHoursCond=null, removeFromLeads=false, vdn=0, couponRules=null}", json);
    }
}
