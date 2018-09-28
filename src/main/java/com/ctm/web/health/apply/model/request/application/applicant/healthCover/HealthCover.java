package com.ctm.web.health.apply.model.request.application.applicant.healthCover;

import com.fasterxml.jackson.annotation.JsonInclude;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class HealthCover {

    private Cover healthCover;

    private HealthCoverLoading healthCoverLoading;

    private EverHadCover everHadCover;

    public HealthCover(final Cover healthCover, final HealthCoverLoading healthCoverLoading, final EverHadCover everHadCover) {
        this.healthCover = healthCover;
        this.healthCoverLoading = healthCoverLoading;
        this.everHadCover = everHadCover;
    }

    public Cover getHealthCover() {
        return healthCover;
    }

    public HealthCoverLoading getHealthCoverLoading() {
        return healthCoverLoading;
    }

    public EverHadCover getEverHadCover() { return everHadCover; }
}
