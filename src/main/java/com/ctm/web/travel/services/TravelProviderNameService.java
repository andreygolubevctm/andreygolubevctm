package com.ctm.web.travel.services;

import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.ProviderName;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Component
public class TravelProviderNameService extends CommonRequestService<Object, List<ProviderName>> {
    private static final Logger LOGGER = LoggerFactory.getLogger(TravelProviderNameService.class);

    @Autowired
    public TravelProviderNameService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }

    public List<ProviderName> getProviderNames(Brand brand, Vertical.VerticalType verticalType, String environmentOverride) throws DaoException {
        final Map<String, String> params = Collections.emptyMap();
        List<ProviderName> providerNames = null;
        try {
            providerNames = sendGETRequestToService(brand, verticalType,
                    "travelQuoteService", Endpoint.ACTIVE_PROVIDER_CODES, environmentOverride, new TypeReference<List<ProviderName>>() {
                    }, params);
        } catch (Exception e) {
            LOGGER.warn("Unable to get the list of active provider codes", e);
            providerNames = Collections.emptyList();
        }
        return providerNames;
    }
}

