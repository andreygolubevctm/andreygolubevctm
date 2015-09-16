package com.ctm.providers.health.healthapply.model.request.fundData.benefits;

import com.ctm.healthapply.model.request.application.situation.HealthSituation;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

public class Benefits {

    @JacksonXmlProperty(localName = "healthSitu")
    private HealthSituation healthSituation;

    public HealthSituation getHealthSituation() {
        return healthSituation;
    }
}
