package com.ctm.web.core.leadService.factories;

import com.ctm.web.core.leadService.models.LeadDataModel;
import com.ctm.web.health.model.HealthLeadDataModel;

public class LeadDataModelFactory {

    public LeadDataModel createLeadDataModel (String vertical) {
        vertical = vertical.toLowerCase();

        LeadDataModel leadDataModel = null;

        switch (vertical) {
            case "health":
                leadDataModel = new HealthLeadDataModel();
                break;
        }

        return leadDataModel;
    }

}
