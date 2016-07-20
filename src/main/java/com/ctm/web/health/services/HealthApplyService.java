package com.ctm.web.health.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.ApplicationOutgoingRequest;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.health.apply.model.RequestAdapter;
import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
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
    private Client<ApplicationOutgoingRequest<HealthApplicationRequest>, HealthApplyResponse> clientApplication;

    @Autowired
    public HealthApplyService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
    }

    public HealthApplyResponse apply(Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {

        final HealthApplicationRequest applicationRequest = RequestAdapter.adapt(data);

        final ApplicationOutgoingRequest<HealthApplicationRequest> request = ApplicationOutgoingRequest.<HealthApplicationRequest>newBuilder()
                .transactionId(data.getTransactionId())
                .brandCode(brand.getCode())
                .requestAt(data.getRequestAt())
                .providerFilter(data.getQuote().getApplication().getProvider())
                .payload(applicationRequest)
                .build();

        final QuoteServiceProperties properties = getQuoteServiceProperties("healthApplyService", brand, HEALTH.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        return clientApplication.post(RestSettings.<ApplicationOutgoingRequest<HealthApplicationRequest>>builder()
                .request(request)
                .jsonHeaders()
                .url(properties.getServiceUrl()+"/apply")
                .timeout(properties.getTimeout())
                .responseType(MediaType.APPLICATION_JSON)
                .response(HealthApplyResponse.class)
                .build())
//                TODO: what to do on error
//                .doOnError(t -> t.printStackTrace())
                .single().toBlocking().single();
    }


}