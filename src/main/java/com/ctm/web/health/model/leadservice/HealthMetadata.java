package com.ctm.web.health.model.leadservice;

import com.ctm.web.core.leadService.model.LeadMetadata;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonTypeName;

import java.util.List;

@JsonTypeName("health")
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class HealthMetadata extends LeadMetadata {

    public static final HealthMetadata EMPTY_HEALTH_METADATA = new HealthMetadata();

    private String situation;
    private Boolean hasPrivateHealthInsurance;
    private String screenSize;

    private HealthMetadata() {
    }

    public HealthMetadata(final String situation,
                          final Boolean hasPrivateHealthInsurance,
                          final String screenSize) {
        this.situation = situation;
        this.hasPrivateHealthInsurance = hasPrivateHealthInsurance;
        this.screenSize = screenSize;
    }

    @Override
    public String getValues() {
        StringBuilder builder = new StringBuilder();
        builder.append(situation);
        builder.append(",");
        builder.append(hasPrivateHealthInsurance);
        builder.append(",");
        builder.append(screenSize);

        return builder.toString();
    }

    @Override
    public String toString() {
        return "HealthMetadata{" +
                "situation=" + situation +
                ", hasPrivateHealthInsurance=" + hasPrivateHealthInsurance +
                ", screenSize=" + screenSize +
                '}';
    }
}