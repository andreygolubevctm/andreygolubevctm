package com.ctm.web.core.coupon.model.request;

import com.ctm.web.core.coupon.model.CouponChannel;

import java.util.Date;

public class CouponRequest {

	public Long transactionId;
	public int styleCodeId;
	public int verticalId;
	public int couponId;
	public String campaignName;
	public String couponCode;
	public double couponValue;
	public CouponChannel couponChannel;
	public Date effectiveDate;
	public String vdn;

}
