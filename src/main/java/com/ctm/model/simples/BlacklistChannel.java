package com.ctm.model.simples;

public enum BlacklistChannel {
	PHONE("phone", "toggle_doNotCall"),
	SMS("sms", "toggle_doNotSms"),
	DIRECTMAIL("directMail", "toggle_doNotDirectMail");

	private final String code, action;

	BlacklistChannel(String code, String action) {
		this.code = code;
		this.action = action;
	}

	public String getCode() {
		return code;
	}

	public String getAction() {
		return action;
	}

	/**
	 * Find a BlacklistChannel by its code.
	 * @param code String e.g. "phone"
	 */
	public static BlacklistChannel findByCode(String code) {
		for (BlacklistChannel c : BlacklistChannel.values()) {
			if (code.equals(c.getCode())) {
				return c;
			}
		}
		return null;
	}
}
