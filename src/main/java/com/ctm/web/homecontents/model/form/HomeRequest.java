package com.ctm.web.homecontents.model.form;

import com.ctm.web.core.model.formData.Request;

public class HomeRequest implements Request<HomeQuote> {

    private Long transactionId;

    private String clientIpAddress;

    private HomeQuote home;

    private String environmentOverride;

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public HomeQuote getQuote() {
        return home;
    }

    public void setQuote(HomeQuote quote) {
        this.home = quote;
    }

    public HomeQuote getHome() {
        return home;
    }

    public void setHome(HomeQuote home) {
        this.home = home;
    }

    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    @Override
    public String toString() {
        return "HomeRequest{" +
                "transactionId=" + transactionId +
                ", clientIpAddress='" + clientIpAddress + '\'' +
                ", home=" + home +
                ", environmentOverride='" + environmentOverride + '\'' +
                '}';
    }
}
