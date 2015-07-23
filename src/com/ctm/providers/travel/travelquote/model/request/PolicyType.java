package com.ctm.providers.travel.travelquote.model.request;

import com.fasterxml.jackson.annotation.JsonValue;

public enum PolicyType {
	SINGLE ("SINGLE"),
	MULTI ("MULTI");

	private final String code;

	PolicyType(final String code) {
		this.code = code;
	}

	@JsonValue
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
