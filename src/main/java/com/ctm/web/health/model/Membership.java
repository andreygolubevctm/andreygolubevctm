package com.ctm.web.health.model;


public enum Membership {

	SINGLE_MALE ("SM"),
	SINGLE_FEMALE ("SF"),
	SINGLE ("S"),
	COUPLE ("C"),
	SINGLE_PARENT ("SP"),
	FAMILY ("F");

	private final String code;

	Membership(String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

	/**
	 * Find a membership type by its code.
	 * @param code Code e.g. P
	 */
	public static Membership findByCode(String code) {
		for (Membership t : Membership.values()) {
			if (code.equalsIgnoreCase(t.getCode())) {
				return t;
			}
		}
		return SINGLE;
	}

}
