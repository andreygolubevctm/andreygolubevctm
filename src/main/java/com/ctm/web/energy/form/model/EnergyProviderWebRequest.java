package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.RequestImpl;

import javax.validation.constraints.NotNull;
import java.util.Optional;

public class EnergyProviderWebRequest extends RequestImpl {

    @NotNull
    private String postcode;

    private String suburb;

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

    public String toString() {
        return "EnergyProviderWebRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", postcode=" + postcode +
                ", suburb=" + suburb +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
