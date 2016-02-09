package com.ctm.web.health.model;


public enum Frequency {
	
	WEEKLY ("weekly" , "W"),
	FORTNIGHTLY ("fortnightly", "F"),
	QUARTERLY ("quarterly", "Q"),
	HALF_YEARLY("halfyearly" , "H"),
	ANNUALLY("annually" ,"A"),
	MONTHLY("monthly" , "M"); 

	private final String description, code;

	Frequency(String description, String code) {
		this.description = description;
		this.code = code;
	}

	public String getDescription() {
		return description;
	}
	public String getCode() {
		return code;
	}


	public static Frequency findByCode(String code) {
		for (Frequency t : Frequency.values()) {
			if (code.equals(t.getCode())) {
				return t;
			}
		}
		return null;
	}
	

	public static Frequency findByDescription(String description) {
		for (Frequency t : Frequency.values()) {
			if (description.equals(t.getDescription())) {
				return t;
			}
		}
		return null;
	}

}
