package com.ctm.web.core.leadService.factories;

import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.services.HealthLeadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

public class LeadServiceFactory {

    protected static final Logger LOGGER = LoggerFactory.getLogger(LeadService.class);

    /**
     * Creates a new lead service based on the specified vertical
     * @return
     */
    public LeadService createLeadService(HttpServletRequest request, Data data) {
        String vertical = data.getString("current/verticalCode").toLowerCase();

        LeadService leadService = null;

        switch (vertical) {
            case "health":
                leadService = new HealthLeadService(request, data);
                break;
        }

        return leadService;
    }

}
