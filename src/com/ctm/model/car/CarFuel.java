package com.ctm.model.car;

public class CarFuel {
	public static final String JSON_COLLECTION_NAME = "fuels";
	public static final String JSON_SINGLE_NAME = "fuel";


	public static enum FuelType {
		ELECTRIC ("Electric", "E"),
		DIESEL ("Diesel", "D"),
		GAS ("Gas", "G"),
		PETROL ("Petrol", "P");

		private final String label, code;

		FuelType(String label, String code) {
			this.label = label;
			this.code = code;
		}

		public String getLabel() {
			return label;
		}
		public String getCode() {
			return code;
		}

		/**
		 * Find a fuel type by its code.
		 * @param code Code e.g. P
		 */
		public static FuelType findByCode(String code) {
			for (FuelType t : FuelType.values()) {
				if (code.equals(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	//---------------------------------------------------------------

	private String code;
	private String label;

	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}

	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}

}
