package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.RequestImpl;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


@JsonIgnoreProperties(ignoreUnknown = true)
public class EnergyResultsWebRequest extends RequestImpl {

    private EnergyPayLoad utilities;

    public EnergyPayLoad getUtilities() {
        return utilities;
    }

    public void setUtilities(EnergyPayLoad utilities) {
        this.utilities = utilities;
    }

    public String toString() {
        return "EnergyResultsWebRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", utilities=" + utilities +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
