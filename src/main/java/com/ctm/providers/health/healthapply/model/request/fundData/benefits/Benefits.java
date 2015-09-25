package com.ctm.providers.health.healthapply.model.request.fundData.benefits;

import com.ctm.providers.health.healthapply.model.request.application.situation.HealthSituation;
import com.fasterxml.jackson.annotation.JsonInclude;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Benefits {

    private HealthSituation healthSituation;

    public Benefits(final HealthSituation healthSituation) {
        this.healthSituation = healthSituation;
    }
}
