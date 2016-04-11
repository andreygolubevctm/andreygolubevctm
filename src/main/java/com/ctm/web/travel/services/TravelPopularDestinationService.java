package com.ctm.web.travel.services;

import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.travel.model.results.Country;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Component
public class TravelPopularDestinationService extends CommonRequestService<Object, List<Country>> {

    private static final Logger LOGGER = LoggerFactory.getLogger(TravelPopularDestinationService.class);

    @Autowired
    public TravelPopularDestinationService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }

    public List<Country> getList(Brand brand, Vertical.VerticalType verticalType, String environmentOverride, Optional<LocalDateTime> applicationDate) throws ServiceConfigurationException, DaoException, IOException {
        final Map<String, String> params;
        if (applicationDate.isPresent()) {
            params = new HashMap<>();
            params.put("effectiveDateTime", DateTimeFormatter.ISO_DATE_TIME.format(applicationDate.get()));
        } else {
            params = Collections.emptyMap();
        }
        try {
            return sendGETRequestToService(brand, verticalType, "travelQuoteService", Endpoint.POPULAR_DESTINATIONS, environmentOverride, new TypeReference<List<Country>>() {}, params);
        } catch (Exception e) {
            LOGGER.warn("Unable to get the list of popular destinations", e);
            return Collections.emptyList();
        }
    }

}
