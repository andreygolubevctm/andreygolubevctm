package com.ctm.web.simples.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class BlacklistOutcome {
    @JsonSerialize
    private String outcome;

    public BlacklistOutcome(String outcome) {
        this.outcome = outcome;
    }

    @Override
    public String toString() {
        return "BlacklistOutcome{" +
                "outcome='" + outcome + '\'' +
                '}';
    }
}
