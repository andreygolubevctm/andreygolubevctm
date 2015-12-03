package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.Request;

import javax.validation.constraints.NotNull;
import java.util.Optional;

public class EnergyProviderWebRequest implements Request {

    private String clientIpAddress;

    private Long transactionId;

    private String environmentOverride;

    @NotNull
    private String postcode;

    private String suburb;

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public String getClientIpAddress() {
        return clientIpAddress;
    }

    @Override
    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    @Override
    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public Optional<String> getSuburb() {
        return Optional.ofNullable(suburb);
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }
}
