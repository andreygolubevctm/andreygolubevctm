package com.ctm.web.core.leadService.factories;

import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.services.HealthLeadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LeadServiceFactory {

    protected static final Logger LOGGER = LoggerFactory.getLogger(LeadService.class);

    /**
     * Creates a new lead service based on the specified vertical
     * @param vertical
     * @return
     */
    public LeadService createLeadService(String vertical, Data data) {
        vertical = vertical.toLowerCase();

        LeadService leadService = null;

        switch (vertical) {
            case "health":
                leadService = new HealthLeadService(vertical, data);
                break;
        }

        return leadService;
    }

}
