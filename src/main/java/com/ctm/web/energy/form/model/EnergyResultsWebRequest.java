package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.Request;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.validation.Valid;


@JsonIgnoreProperties(ignoreUnknown = true)
public class EnergyResultsWebRequest implements Request {
    private String clientIpAddress;

    private HouseHoldDetails houseHoldDetails;
    private EstimateDetails estimateDetails;
    private String tariff;

    @Valid
    public ResultsDisplayed resultsDisplayed;

    private String referenceNumber;

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

    private Long transactionId;

    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    private String environmentOverride;

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public ResultsDisplayed getResultsDisplayed() {
        return resultsDisplayed;
    }
}
