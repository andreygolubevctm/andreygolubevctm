package com.ctm.providers.health.healthapply.model.request.application;

import com.ctm.providers.health.healthapply.model.request.application.applicant.Applicant;
import com.ctm.providers.health.healthapply.model.request.application.dependant.Dependant;
import com.ctm.providers.health.healthapply.model.request.application.situation.Situation;

import java.util.List;

public class ApplicationGroup {

    private Applicant primary;

    private Applicant partner;

    private List<Dependant> dependants;

    private Situation situation;

    public ApplicationGroup(final Applicant primary, final Applicant partner, final List<Dependant> dependants, final Situation situation) {
        this.primary = primary;
        this.partner = partner;
        this.dependants = dependants;
        this.situation = situation;
    }
}
