package com.ctm.web.energy.form.model;

import com.ctm.web.utilities.model.request.Details;

import javax.validation.Valid;
import java.util.Date;

public class EnergyResultsRequestModel {

    private HouseHoldDetails houseHoldDetails;
	private EstimateDetails estimateDetails;

	private Date connectionDate; // date moving to the property
	private String tariff;


	@Valid
	public Details resultsDisplayed = new Details();

	private String referenceNumber;

	public Date getConnectionDate() {
		return connectionDate;
	}

	public void setConnectionDate(Date connectionDate) {
		this.connectionDate = connectionDate;
	}

	public String getTariff() {
		return tariff;
	}

	public void setTariff(String tariff) {
		this.tariff = tariff;
	}

	public String getReferenceNumber() {
		return referenceNumber;
	}

	public void setReferenceNumber(String referenceNumber) {
		this.referenceNumber = referenceNumber;
	}

    public HouseHoldDetails getHouseHoldDetails() {
        return houseHoldDetails;
    }

    public void setHouseHoldDetails(HouseHoldDetails houseHoldDetails) {
        this.houseHoldDetails = houseHoldDetails;
    }


	public EstimateDetails getEstimateDetails() {
		return estimateDetails;
	}

	public void setEstimateDetails(EstimateDetails estimateDetails) {
		this.estimateDetails = estimateDetails;
	}
}
