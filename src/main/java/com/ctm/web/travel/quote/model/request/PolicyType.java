package com.ctm.web.travel.quote.model.request;

/**
 * Part of the request model for calling CtM's travel-quote application.
 *
 * Data model representing if the trip is Single or annual multi-trip
 */
public enum PolicyType {

	SINGLE ("SINGLE"),
	MULTI ("MULTI");

	private final String code;

	PolicyType(final String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

	public static PolicyType findByCode(final String code) {
		for (final PolicyType t : PolicyType.values()) {
			if (code.equals(t.getCode())) {
				return t;
			}
		}
		return null;
	}

	public static PolicyType fromValue(final String v) {
		return findByCode(v);
	}
}
