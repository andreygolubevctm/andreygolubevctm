package com.ctm.providers.health.healthapply.model;

import com.ctm.model.health.form.HealthRequest;
import com.ctm.providers.health.healthapply.model.request.HealthApplicationRequest;

public class HealthApplicationRequestBuilder {

    public HealthApplicationRequest build(final HealthRequest data) {
        return new HealthApplicationRequest();
    }

}
