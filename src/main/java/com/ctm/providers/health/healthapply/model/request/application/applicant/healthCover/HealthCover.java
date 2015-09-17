package com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover;

public class HealthCover {

    private Cover healthCover;

    private HealthCoverLoading healthCoverLoading;

    public HealthCover(final Cover healthCover, final HealthCoverLoading healthCoverLoading) {
        this.healthCover = healthCover;
        this.healthCoverLoading = healthCoverLoading;
    }

}
