package com.ctm.web.health.apply.model.request.fundData.benefits;

import com.ctm.web.health.apply.model.request.application.situation.HealthSituation;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.ArrayList;
import java.util.List;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Benefits {

    private HealthSituation healthSituation;

    private List<String> benefits = new ArrayList<>();

    public Benefits(HealthSituation healthSituation, List<String> benefits) {
        this.healthSituation = healthSituation;
        this.benefits = benefits;
    }

}
