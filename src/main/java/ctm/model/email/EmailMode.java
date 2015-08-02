package com.ctm.model.email;


public enum EmailMode {
	QUOTE{
		public String toString() {
			return "quote";
		}
	},
	APP{
		public String toString() {
			return "app";
		}
	},
	EDM{
		public String toString() {
			return "edm";
		}
	},
	BEST_PRICE{
		public String toString() {
			return "bestprice";
		}
	},
	PRODUCT_BROCHURES {
		public String toString() {
			return "brochures";
		}
	},
	PROMOTION{
		public String toString() {
			return "promotion";
		}
	};

	/**
	 * Find a vertical type by its id.
	 * @param code Code e.g. P
	 */
	public static EmailMode findByCode(String code) {
		for (EmailMode t : EmailMode.values()) {
			if (code.equalsIgnoreCase(t.toString())) {
				return t;
			}
		}
		return null;
	}
}
