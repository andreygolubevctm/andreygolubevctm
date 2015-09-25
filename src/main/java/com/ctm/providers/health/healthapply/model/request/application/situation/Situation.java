package com.ctm.providers.health.healthapply.model.request.application.situation;

import com.fasterxml.jackson.annotation.JsonInclude;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Situation {

    private HealthSituation healthSituation;

    private HealthCoverCategory coverCategory;

    public Situation(final HealthSituation healthSituation, final HealthCoverCategory coverCategory) {
        this.healthSituation = healthSituation;
        this.coverCategory = coverCategory;
    }
}
