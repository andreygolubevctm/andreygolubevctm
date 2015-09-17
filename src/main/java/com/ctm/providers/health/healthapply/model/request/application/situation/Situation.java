package com.ctm.providers.health.healthapply.model.request.application.situation;

public class Situation {

    private HealthSituation healthSituation;

    private HealthCoverCategory coverCategory;

    public Situation(final HealthSituation healthSituation, final HealthCoverCategory coverCategory) {
        this.healthSituation = healthSituation;
        this.coverCategory = coverCategory;
    }
}
