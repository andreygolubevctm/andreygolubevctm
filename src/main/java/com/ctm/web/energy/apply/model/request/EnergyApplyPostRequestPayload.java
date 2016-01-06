package com.ctm.web.energy.apply.model.request;

import com.ctm.web.core.model.formData.RequestImpl;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class EnergyApplyPostRequestPayload extends RequestImpl {
    private EnergyApplicationPayload utilities;

    public EnergyApplicationPayload getUtilities() {
        return utilities;
    }

    public void setUtilities(EnergyApplicationPayload utilities) {
        this.utilities = utilities;
    }

    public String toString() {
        return "EnergyApplyPostRequestPayload{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", utilities=" + utilities +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }


}
