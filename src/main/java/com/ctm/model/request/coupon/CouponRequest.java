package com.ctm.model.request.coupon;

import java.util.Date;

import com.ctm.model.coupon.CouponChannel;

public class CouponRequest {

	public Long transactionId;
	public int styleCodeId;
	public int verticalId;
	public int couponId;
	public String couponCode;
	public CouponChannel couponChannel;
	public Date effectiveDate;
	public String vdn;

}
