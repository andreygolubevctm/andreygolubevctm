package com.ctm.model.email;

public class TravelBestPriceRanking extends BestPriceRanking {

	private String medical;
	private String cancellation;
	private String luggage;
	private String coverLevelType;

	public void setMedical(String medical) {
		this.medical = medical;
	}

	public String getMedical() {
		return medical;
	}

	public void setCancellation(String cancellation) {
		this.cancellation = cancellation;
	}

	public String getCancellation() {
		return cancellation;
	}

	public void setLuggage(String luggage) {
		this.luggage = luggage;
	}

	public String getLuggage() {
		return luggage;
	}

	public void setCoverLevelType(String coverLevelType) {
		this.coverLevelType = coverLevelType;
	}

	public String getCoverLevelType() {
		return coverLevelType;
	}
}
