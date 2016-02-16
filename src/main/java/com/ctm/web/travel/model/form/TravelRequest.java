package com.ctm.web.travel.model.form;

import com.ctm.web.core.model.formData.RequestWithQuote;

public class TravelRequest extends RequestWithQuote<TravelQuote> {

    private TravelQuote travel;

    @Override
    public TravelQuote getQuote() {
        return travel;
    }

    public void setTravel(TravelQuote quote) {
        this.travel = quote;
    }

    public TravelQuote getTravel() {
        return travel;
    }

    public String toString() {
        return "TravelRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", travel=" + getQuote() +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
