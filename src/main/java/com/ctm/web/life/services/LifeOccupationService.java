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
import com.ctm.web.life.model.LifeQuoteResponse;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import com.ctm.web.core.services.*;
import com.fasterxml.jackson.core.type.TypeReference;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.LIFE;

@Component
public class LifeOccupationService  {

    private final RestClient restClient;

    @Value("${life.occupation.environmentOverride}")
    private String environmentOverride;

    private final CommonRequestService requestService;

    @Autowired
    public LifeOccupationService(RestClient restClient, CommonRequestService requestService) {
        this.restClient = restClient;
        this.requestService = requestService;
    }

    public List<Occupation> getOccupations(Brand brand) throws DaoException, IOException, ServiceConfigurationException {
            final Vertical.VerticalType verticalType = LIFE;
            return restClient.sendGETRequest(
                    requestService.getQuoteServiceProperties("quoteServiceBER", brand, verticalType.getCode(),
                            Optional.ofNullable(StringUtils.trimToNull(environmentOverride))),
                    Endpoint.instanceOf("occupations"),
                    new TypeReference<List<Occupation>>() {
                    }, Collections.emptyMap());
    }

}
