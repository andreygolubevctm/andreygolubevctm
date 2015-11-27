package com.ctm.web.energy.form.response.model;

import com.ctm.web.core.resultsData.model.Info;

import java.util.List;


public class EnergyResultsWebResponse {

    private final List<EnergyResponseError> errors;
    private EnergyResults results;
    private Info info;

    public EnergyResultsWebResponse(EnergyResults results, List<EnergyResponseError> errors){
        this.results= results;
        this.errors = errors;

    }

    public long transactionId;

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    public EnergyResults getResults() {
        return results;
    }

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }

    public List<EnergyResponseError> getErrors() {
        return errors;
    }
}
