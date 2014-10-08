package com.ctm.model.travel;

public enum Destination {
		AFRICA ("Africa" , "af:af"),
		USA ("USA", "am:us"),
		CANADA ("Canada", "am:ca"),
		SOUTH_AMERICA ("South America" , "am:sa"),
		CHINA ("China" ,"as:ch"),
		HONG_KONG("Hong Kong" , "as:hk"),
		JAPAN("Japan" , "as:jp"),
		INDIA("India" , "as:in"),
		THAILAND("Thailand" , "as:th"),
		AUSTRALIA ("Australia" ,"pa:au"),
		BALI("Bali" , "pa:ba"),
		INDONESIA("Indonesia" , "pa:in"),
		NEW_ZEALAND("New Zealand" , "pa:nz"),
		PACIFIC_ISLANDS("Pacific Islands" , "pa:pi"),
		EUROPE("Europe" , "eu:eu"),
		UK("UK" , "eu:uk"),
		MIDDLE_EAST("Middle East" , "me:me"),
		OTHER ("Any other Country" , "do:do"),;

		private final String description, code;

		Destination(String description, String code) {
			this.description = description;
			this.code = code;
		}

		public String getDescription() {
			return description;
		}
		public String getCode() {
			return code;
		}

		/**
		 * Return a destination description by its code.
		 * @param code Code e.g. pa:au returns Australia
		 */
		public static String findDescriptionByCode(String code) {
			for (Destination t : Destination.values()) {
				if (code.equals(t.getCode())) {
					return t.getDescription();
				}
			}
			return "";
		}
}
