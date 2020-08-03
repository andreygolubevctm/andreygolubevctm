package com.ctm.web.simples.model;

public class Event {
    private String transactionId;
    private String rootId;
    private String gaId;
    private String step;

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getRootId() {
        return rootId;
    }

    public void setRootId(String rootId) {
        this.rootId = rootId;
    }

    public String getGaId() {
        return gaId;
    }

    public void setGaId(String gaId) {
        this.gaId = gaId;
    }

    public String getStep() {
        return step;
    }

    public void setStep(String step) {
        this.step = step;
    }
}
