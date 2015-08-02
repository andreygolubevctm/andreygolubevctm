package com.ctm.model.health;

public enum HospitalSelection {
	PUBLIC_HOSPITAL ("PublicHospital"),
	PRIVATE_HOSPITAL ("PrivateHospital"),
	BOTH ("BOTH");

	private final String code;

	HospitalSelection(String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

	/**
	 * Find a hospital type by its code.
	 * @param code Code e.g. PublicHospital
	 */
	public static HospitalSelection findByCode(String code) {
		for (HospitalSelection c : HospitalSelection.values()) {
			if (code.equals(c.getCode())) {
				return c;
			}
		}
		return null;
	}
}
