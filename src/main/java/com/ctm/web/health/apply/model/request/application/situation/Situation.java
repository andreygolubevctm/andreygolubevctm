package com.ctm.web.health.apply.model.request.application.situation;

import com.fasterxml.jackson.annotation.JsonInclude;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Situation {

    private HealthCoverCategory coverCategory;

    public Situation(final HealthCoverCategory coverCategory) {
        this.coverCategory = coverCategory;
    }

    public HealthCoverCategory getCoverCategory() {
        return coverCategory;
    }
}
