package com.ctm.web.homecontents.model.form;

import com.ctm.web.core.model.formData.RequestWithQuote;

public class HomeRequest extends RequestWithQuote<HomeQuote> {

    private HomeQuote home;

    @Override
    public HomeQuote getQuote() {
        return home;
    }

    public void setHome(HomeQuote home) {
        this.home = home;
    }

    public HomeQuote getHome() {
        return home;
    }

    public String toString() {
        return "HomeRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", home=" + getQuote() +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }


}
