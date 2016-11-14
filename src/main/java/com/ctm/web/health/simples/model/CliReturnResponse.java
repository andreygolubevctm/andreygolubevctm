package com.ctm.web.health.simples.model;

public class CliReturnResponse {

    public CliReturnResponse(String outcome) {
        this.outcome = outcome;
    }

    private String outcome;

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
