package com.ctm.web.health.simples.model;

public class CliReturnResponse {

    public CliReturnResponse(final String outcome) {
        this.outcome = outcome;
    }

    private final String outcome;

    public String getOutcome() {
        return outcome;
    }

    @Override
    public String toString() {
        return "CliReturnResponse{" +
                "outcome='" + outcome + '\'' +
                '}';
    }
}
