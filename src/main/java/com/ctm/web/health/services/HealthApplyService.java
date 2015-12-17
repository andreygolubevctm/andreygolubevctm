package com.ctm.web.health.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.apply.model.RequestAdapter;
import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

public class HealthApplyService extends CommonQuoteService<HealthQuote, HealthApplicationRequest, HealthApplyResponse> {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplyService.class);

    public HealthApplyService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper(), new SimpleConnection());
    }

    public HealthApplyResponse apply(Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {

        final HealthApplicationRequest request = RequestAdapter.adapt(data);

        return sendRequest(brand, HEALTH, "healthApplyService", Endpoint.APPLY, data, request, HealthApplyResponse.class);
    }


}
