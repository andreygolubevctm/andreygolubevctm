package com.ctm.web.car.model.form;

import com.ctm.web.core.model.formData.RequestWithQuote;

public class CarRequest extends RequestWithQuote<CarQuote> {

    private CarQuote quote;

    @Override
    public CarQuote getQuote() {
        return quote;
    }

    public void setQuote(CarQuote quote) {
        this.quote = quote;
    }

    public String toString() {
        return "CarRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", car=" + getQuote() +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }

}
