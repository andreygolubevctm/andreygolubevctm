package com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover;

import com.fasterxml.jackson.annotation.JsonInclude;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class HealthCover {

    private Cover healthCover;

    private HealthCoverLoading healthCoverLoading;

    public HealthCover(final Cover healthCover, final HealthCoverLoading healthCoverLoading) {
        this.healthCover = healthCover;
        this.healthCoverLoading = healthCoverLoading;
    }

}
