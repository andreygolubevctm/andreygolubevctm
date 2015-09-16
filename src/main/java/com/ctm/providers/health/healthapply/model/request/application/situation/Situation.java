package com.ctm.providers.health.healthapply.model.request.application.situation;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

public class Situation {

    private HealthSituation healthSituation;

    @JsonProperty("coverCategory")
    private HealthCoverCategory coverCategory;

    public Optional<HealthSituation> getHealthSituation() {
        return Optional.ofNullable(healthSituation);
    }

    public Optional<HealthCoverCategory> getHealthCover() {
        return Optional.ofNullable(coverCategory);
    }


}
