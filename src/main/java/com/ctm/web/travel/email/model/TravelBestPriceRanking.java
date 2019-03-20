package com.ctm.web.travel.email.model;

import com.ctm.web.core.email.model.BestPriceRanking;

public class TravelBestPriceRanking extends BestPriceRanking {

	private String medical;
	private String cancellation;
	private String luggage;
	private String coverLevelType;
	private String rentalVehicle;

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

	public void setRentalVehicle(String rentalVehicle) {
		this.rentalVehicle = rentalVehicle;
	}

	public String getRentalVehicle() {
		return rentalVehicle;
	}


	public void setCoverLevelType(String coverLevelType) {
		this.coverLevelType = coverLevelType;
	}

	public String getCoverLevelType() {
		return coverLevelType;
	}
}
