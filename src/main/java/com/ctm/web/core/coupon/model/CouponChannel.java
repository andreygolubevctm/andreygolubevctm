package com.ctm.web.core.coupon.model;

public enum CouponChannel {
	AVAILABLE_ALL (""),
	ONLINE ("O"),
	CALL_CENTRE ("C");

	private final String code;

	CouponChannel(String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

	/**
	 * Find a coupon channel by its code.
	 * @param code Code e.g. O
	 */
	public static CouponChannel findByCode(String code) {
		for (CouponChannel t : CouponChannel.values()) {
			if (code.equalsIgnoreCase(t.getCode())) {
				return t;
			}
		}
		return null;
	}
}