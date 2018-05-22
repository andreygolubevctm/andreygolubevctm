package com.ctm.web.health.model.leadservice;

public class DelayLeadResponse {

    public DelayLeadResponse(final String outcome) {
        this.outcome = outcome;
    }

    private final String outcome;

    public String getOutcome() {
        return outcome;
    }

    @Override
    public String toString() {
        return "DelayLeadResponse{" +
                "outcome='" + outcome + '\'' +
                '}';
    }
}
