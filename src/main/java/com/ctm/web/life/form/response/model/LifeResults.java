package com.ctm.web.life.form.response.model;

import com.ctm.web.life.form.model.Api;

public class LifeResults {

    private ResultPremiums client;

    private ResultPremiums partner;

    private boolean success;

    private Api api;

    private Long transactionId;

    public ResultPremiums getClient() {
        return client;
    }

    public void setClient(ResultPremiums client) {
        this.client = client;
    }

    public ResultPremiums getPartner() {
        return partner;
    }

    public void setPartner(ResultPremiums partner) {
        this.partner = partner;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Api getApi() {
        return api;
    }

    public void setApi(Api api) {
        this.api = api;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
