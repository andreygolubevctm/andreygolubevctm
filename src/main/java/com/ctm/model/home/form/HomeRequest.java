package com.ctm.model.home.form;

import com.ctm.model.Request;

public class HomeRequest implements Request<HomeQuote> {

    private String transactionId;

    private String clientIpAddress;

    private HomeQuote home;

    @Override
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
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
}
