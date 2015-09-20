package com.ctm.services.health;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.health.form.HealthQuote;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.settings.Brand;
import com.ctm.providers.health.healthapply.model.RequestAdapter;
import com.ctm.providers.health.healthapply.model.request.HealthApplicationRequest;
import com.ctm.providers.health.healthapply.model.response.HealthApplyResponse;
import com.ctm.services.CommonQuoteService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

public class HealthApplyService extends CommonQuoteService<HealthQuote, HealthApplicationRequest, HealthApplyResponse> {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplyService.class);

    public HealthApplyResponse apply(Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {

        final HealthApplicationRequest request = RequestAdapter.adapt(data);

        return sendRequest(brand, HEALTH, "healthApplyService", "HEALTH-APPLY", "apply", data, request, HealthApplyResponse.class);
    }


}
