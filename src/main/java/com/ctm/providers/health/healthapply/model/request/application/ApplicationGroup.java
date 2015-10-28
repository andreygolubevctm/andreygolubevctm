package com.ctm.providers.health.healthapply.model.request.application;

import com.ctm.providers.health.healthapply.model.request.application.applicant.Applicant;
import com.ctm.providers.health.healthapply.model.request.application.dependant.Dependant;
import com.ctm.providers.health.healthapply.model.request.application.situation.Situation;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.List;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class ApplicationGroup {

    private Applicant primary;

    private Applicant partner;

    private List<Dependant> dependants;

    private Situation situation;

    private Emigrate emigrate;

    public ApplicationGroup(final Applicant primary,
                            final Applicant partner,
                            final List<Dependant> dependants,
                            final Situation situation,
                            final Emigrate emigrate) {
        this.primary = primary;
        this.partner = partner;
        this.dependants = dependants;
        this.situation = situation;
        this.emigrate = emigrate;
    }

    public Applicant getPrimary() {
        return primary;
    }

    public Applicant getPartner() {
        return partner;
    }

    public List<Dependant> getDependants() {
        return dependants;
    }

    public Situation getSituation() {
        return situation;
    }

    public Emigrate getEmigrate() {
        return emigrate;
    }
}
