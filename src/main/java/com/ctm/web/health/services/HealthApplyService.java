package com.ctm.web.health.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.ApplicationOutgoingRequest;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.health.apply.model.RequestAdapter;
import com.ctm.web.health.apply.model.RequestAdapterV2;
import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponsePrev;
import com.ctm.web.health.model.form.HealthRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Component
public class HealthApplyService extends CommonRequestServiceV2 {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplyService.class);

    @Autowired
    private Client<com.ctm.web.core.providers.model.Request<HealthApplicationRequest>, HealthApplyResponsePrev> clientApplication;

    @Autowired
    private Client<ApplicationOutgoingRequest<HealthApplicationRequest>, HealthApplyResponse> clientV2Application;

    @Autowired
    public HealthApplyService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
    }

    public HealthApplyResponse apply(Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {

        final QuoteServiceProperties properties = getQuoteServiceProperties("healthApplyService", brand, HEALTH.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        if (properties.getServiceUrl().contains("-v2/") || properties.getServiceUrl().startsWith("http://localhost")) {
            // Version 2
            final ApplicationOutgoingRequest<HealthApplicationRequest> request = ApplicationOutgoingRequest.<HealthApplicationRequest>newBuilder()
                    .transactionId(data.getTransactionId())
                    .brandCode(brand.getCode())
                    .requestAt(data.getRequestAt())
                    .providerFilter(data.getQuote().getApplication().getProvider())
                    .payload(RequestAdapterV2.adapt(data))
                    .build();

            return clientV2Application.post(RestSettings.<ApplicationOutgoingRequest<HealthApplicationRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl()+"/apply")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(HealthApplyResponse.class)
                    .build())
                    .single().toBlocking().single();

        } else {
            // Version 1
            final com.ctm.web.core.providers.model.Request<HealthApplicationRequest> request = createRequest(brand, data, RequestAdapter.adapt(data));

            final HealthApplyResponsePrev response = clientApplication.post(RestSettings.<com.ctm.web.core.providers.model.Request<HealthApplicationRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/apply")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(HealthApplyResponsePrev.class)
                    .build())
                    .single().toBlocking().single();
            HealthApplyResponse healthApplyResponse = new HealthApplyResponse();
            healthApplyResponse.setTransactionId(response.getTransactionId());
            final HealthApplicationResponse healthApplicationResponse = response.getPayload().getQuotes()
                    .stream()
                    .findFirst()
                    .orElseThrow(() -> new RouterException("No Payload from response"));
            healthApplyResponse.setPayload(healthApplicationResponse);
            return healthApplyResponse;
        }
    }

    @Deprecated
    private com.ctm.web.core.providers.model.Request<HealthApplicationRequest> createRequest(Brand brand, HealthRequest data, HealthApplicationRequest payload) {
        com.ctm.web.core.providers.model.Request<HealthApplicationRequest> request = new com.ctm.web.core.providers.model.Request<>();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());
        request.setPayload(payload);
        request.setRequestAt(data.getRequestAt());
        return request;
    }

}