package com.ctm.providers.health.healthapply.model.request.application;

import com.ctm.healthapply.model.request.application.applicant.Applicant;
import com.ctm.healthapply.model.request.application.dependant.Dependant;
import com.ctm.healthapply.model.request.application.situation.Situation;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

public class ApplicationGroup {

    private Applicant primary;

    private Applicant partner;

    private List<Dependant> dependants;

    private Situation situation;

    public Optional<Applicant> getPrimary() {
        return Optional.ofNullable(primary);
    }

    public Optional<Applicant> getPartner() {
        return Optional.ofNullable(partner);
    }

    public List<Dependant> getDependants() {
        return dependants == null ? Collections.emptyList() : dependants;
    }

    public Optional<Situation> getSituation() {
        return Optional.ofNullable(situation);
    }
}
