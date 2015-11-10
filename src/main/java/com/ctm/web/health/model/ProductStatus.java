package com.ctm.web.health.model;

public enum ProductStatus {
	AVAILABLE_ALL (""),
	ONLINE ("O"),
	CALL_CENTRE ("C"),
	NOT_AVAILABLE ("N"),
	EXPIRED ("X");

	private final String code;

	ProductStatus(String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

	/**
	 * Find a membership type by its code.
	 * @param code Code e.g. P
	 */
	public static ProductStatus findByCode(String code) {
		for (ProductStatus t : ProductStatus.values()) {
			if (code.equalsIgnoreCase(t.getCode())) {
				return t;
			}
		}
		return AVAILABLE_ALL;
	}
}