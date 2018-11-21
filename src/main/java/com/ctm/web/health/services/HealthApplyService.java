package com.ctm.web.health.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.Simples;
import com.ctm.web.health.model.form.Tracking;
import com.ctm.web.core.providers.model.ApplicationOutgoingRequest;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.health.apply.model.RequestAdapter;
import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponsePrev;
import com.ctm.web.health.apply.model.RequestAdapterV2;
import com.ctm.web.health.model.form.HealthRequest;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import rx.schedulers.Schedulers;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Component
public class HealthApplyService extends CommonRequestServiceV2 {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplyService.class);

    @Autowired
    private Client<com.ctm.web.core.providers.model.Request<HealthApplicationRequest>, HealthApplyResponsePrev> clientApplication;

    @Autowired
    private Client<ApplicationOutgoingRequest<HealthApplicationRequest>, HealthApplyResponse> clientV2Application;

    @Autowired
    private TransactionDao transactionDao;

    @Autowired
    private SessionDataServiceBean sessionDataServiceBean;

    @Autowired
    public HealthApplyService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
    }

    public HealthApplyResponse apply(HttpServletRequest httpServletRequest, Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {

        final QuoteServiceProperties properties = getQuoteServiceProperties("healthApplyService", brand, HEALTH.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        if (properties.getServiceUrl().matches(".*://.*/health-apply-v2.*") || properties.getServiceUrl().startsWith("http://localhost")) {
            LOGGER.info("Calling health-apply v2");

            String operator = null;
            String trialCampaign = getTrialCampaignFromData(data);
            String cid = getCidFromData(data);
            AuthenticatedData authenticatedSessionData = sessionDataServiceBean.getAuthenticatedSessionData(httpServletRequest);
            if (authenticatedSessionData != null) {
                operator = authenticatedSessionData.getUid();
            }

            LOGGER.debug("Found {}, {}, {} from {}", kv("operator", operator), kv("cid", cid), kv("trialCampaign", trialCampaign), kv("transactionId", data.getTransactionId()));

            // Version 2
            final ApplicationOutgoingRequest<HealthApplicationRequest> request = ApplicationOutgoingRequest.<HealthApplicationRequest>newBuilder()
                    .transactionId(data.getTransactionId())
                    .brandCode(brand.getCode())
                    .requestAt(data.getRequestAt())
                    .providerFilter(data.getQuote().getApplication().getProvider())
                    .payload(RequestAdapterV2.adapt(data, operator, cid, trialCampaign))
                    .build();

            // Getting RootId from the transactionId
            final long rootId = transactionDao.getRootIdOfTransactionId(data.getTransactionId());
            LOGGER.debug("Getting {} from {}", kv("rootId", rootId), kv("transactionId", data.getTransactionId()));

            return clientV2Application.post(RestSettings.<ApplicationOutgoingRequest<HealthApplicationRequest>>builder()
                    .request(request)
                    .header("rootId", Long.toString(rootId))
                    .jsonHeaders()
                    .url(properties.getServiceUrl()+"/apply")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(HealthApplyResponse.class)
                    .build())
                    .doOnError(this::logHttpClientError)
                    .observeOn(Schedulers.io()).toBlocking().single();

        } else {
            LOGGER.info("Calling health-apply v1");
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
                    .doOnError(this::logHttpClientError)
                    .observeOn(Schedulers.io()).toBlocking().single();
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

	private String getCidFromData(HealthRequest data) {
		Optional<String> trialCampaign = Optional.empty();
		Optional<HealthQuote> quote = Optional.ofNullable(data.getQuote());
		if(quote.isPresent()) {
			Optional<Tracking> tracking = Optional.ofNullable(quote.get().getTracking());
			if(tracking.isPresent()) {
				trialCampaign = Optional.ofNullable(tracking.get().getCid());
			}
		}
		return trialCampaign.isPresent() ? trialCampaign.get() : null;
	}

	private String getTrialCampaignFromData(HealthRequest data) {
		Optional<String> trialCampaign = Optional.empty();
		Optional<HealthQuote> quote = Optional.ofNullable(data.getQuote());
		if(quote.isPresent()) {
			Optional<Simples> simples = Optional.ofNullable(quote.get().getSimples());
			if(simples.isPresent()) {
				trialCampaign = Optional.ofNullable(simples.get().getContactTypeRadio());
			}
		}
		return trialCampaign.isPresent() ? trialCampaign.get() : null;
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