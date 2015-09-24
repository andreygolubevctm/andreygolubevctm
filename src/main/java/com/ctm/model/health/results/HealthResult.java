package com.ctm.model.health.results;

import com.ctm.providers.health.healthapply.model.response.HealthApplyResponse;

public class HealthResult {

    private HealthApplyResponse result;

    public HealthApplyResponse getResult() {
        return result;
    }

    public void setResult(HealthApplyResponse result) {
        this.result = result;
    }
}
