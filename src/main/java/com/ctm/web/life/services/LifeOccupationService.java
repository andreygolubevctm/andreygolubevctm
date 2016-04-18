package com.ctm.web.life.services;

import com.ctm.life.occupation.model.response.Occupation;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.RestClient;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.LIFE;

@Component
public class LifeOccupationService extends CommonRequestService {

    private RestClient restClient;

    @Autowired
    public LifeOccupationService(ProviderFilterDao providerFilterDAO, RestClient restClient, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
        this.restClient = restClient;
    }

    public List<Occupation> getOccupations(Brand brand) throws DaoException, IOException, ServiceConfigurationException {
        final Vertical.VerticalType verticalType = LIFE;
        return restClient.sendGETRequest(
                getQuoteServiceProperties("quoteServiceBER", brand, verticalType.getCode(),
                        Optional.empty()),
                Endpoint.instanceOf("occupations"),
                new TypeReference<List<Occupation>>() {
                }, Collections.emptyMap());
    }

}
