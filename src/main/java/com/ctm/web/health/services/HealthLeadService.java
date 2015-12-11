package com.ctm.web.health.services;

import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.web.go.Data;

public class HealthLeadService extends LeadService {

    public HealthLeadService(String vertical, Data data) {
        super(vertical, 4, data);
    }

    @Override
    protected void updateVerticalPayloadData() {
        LOGGER.info("HEALTH PAYLOAD DATA");
    }

}
