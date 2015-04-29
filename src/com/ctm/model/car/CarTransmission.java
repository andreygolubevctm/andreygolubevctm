package com.ctm.model.car;

public class CarTransmission {
	public static final String JSON_COLLECTION_NAME = "transmissions";


	public static enum TransmissionType {
		AUTOMATIC ("Automatic", "A"),
		DUAL_CLUTCH ("Dual clutch", "D"),
		MANUAL ("Manual", "M"),
		REDUCTION ("Reduction Gear", "R"),
		SEMI_AUTOMATIC ("Semi-Automatic", "S");

		private final String label, code;

		TransmissionType(String label, String code) {
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
		 * Find a transmission type by its code.
		 * @param code Code e.g. R
		 */
		public static TransmissionType findByCode(String code) {
			for (TransmissionType t : TransmissionType.values()) {
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
