package com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover;

import java.util.Optional;

public class HealthCover {

    public static HealthCover NONE = new HealthCover();

    private HealthCover healthCover;

    private HealthCoverLoading healthCoverLoading;

    private HealthCover() {
        healthCover = null;
        healthCoverLoading = null;
    }

    public Optional<HealthCover> getHealthCover() {
        return Optional.ofNullable(healthCover);
    }

    public Optional<HealthCoverLoading> getHealthCoverLoading(){
        return Optional.ofNullable(healthCoverLoading);
    }
}
