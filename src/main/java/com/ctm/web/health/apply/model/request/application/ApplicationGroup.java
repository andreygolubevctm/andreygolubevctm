package com.ctm.web.health.apply.model.request.application;

import com.ctm.web.health.apply.model.request.application.GovernmentRebate.GovernmentRebateAck;
import com.ctm.web.health.apply.model.request.application.applicant.Applicant;
import com.ctm.web.health.apply.model.request.application.dependant.Dependant;
import com.ctm.web.health.apply.model.request.application.situation.Situation;
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

    private GovernmentRebateAck governmentRebateAck;

    public ApplicationGroup(final Applicant primary,
                            final Applicant partner,
                            final List<Dependant> dependants,
                            final Situation situation,
                            final Emigrate emigrate,
                            final GovernmentRebateAck governmentRebateAck) {
        this.primary = primary;
        this.partner = partner;
        this.dependants = dependants;
        this.situation = situation;
        this.emigrate = emigrate;
        this.governmentRebateAck = governmentRebateAck;
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

    public GovernmentRebateAck getGovernmentRebateAck() {
        return governmentRebateAck;
    }
}
