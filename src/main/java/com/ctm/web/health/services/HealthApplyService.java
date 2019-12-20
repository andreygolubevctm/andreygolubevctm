package com.ctm.web.health.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.resultsData.PricesObj;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.ApplicationOutgoingRequest;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.JourneyUpdateService;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.apply.model.RequestAdapter;
import com.ctm.web.health.apply.model.RequestAdapterV2;
import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponsePrev;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Simples;
import com.ctm.web.health.model.form.Tracking;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.utils.HealthRequestParser;
import com.fasterxml.jackson.core.type.TypeReference;
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
import static com.ctm.web.core.security.AuthorisationConstants.TOKEN_REQUEST_PARAM_ANONYMOUS_ID;
import static com.ctm.web.core.security.AuthorisationConstants.TOKEN_REQUEST_PARAM_USER_ID;

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
    private JourneyUpdateService journeyUpdateService;

    @Autowired
    private HealthSelectedProductService healthSelectedProductService;

    @Autowired
    public HealthApplyService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
    }

    public HealthApplyResponse apply(HttpServletRequest httpServletRequest, Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {

        final QuoteServiceProperties properties = getQuoteServiceProperties("healthApplyService", brand, HEALTH.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        Long transactionId = data.getTransactionId(); // transactionId cannot be null.

        // The two IDs below gets populated by the AuthenticationFilter, which extracts them from the relevant JWT token
        final String anonymousId = Optional.ofNullable(httpServletRequest.getAttribute(TOKEN_REQUEST_PARAM_ANONYMOUS_ID)).map(Object::toString).orElse(null);
        final String userId = Optional.ofNullable(httpServletRequest.getAttribute(TOKEN_REQUEST_PARAM_USER_ID)).map(Object::toString).orElse(null);

        if (anonymousId != null || userId != null) {
            transactionDao.writeAuthIDs(transactionId, anonymousId, userId);
            journeyUpdateService.publishInteraction("health", transactionId.toString(), anonymousId, userId);
        }

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
            final HealthQuoteResult selectedProduct;
            try {
                String productId = HealthRequestParser.getProductIdFromHealthRequest(data);
                String productXml = healthSelectedProductService.getProductXML(transactionId, productId);
                PricesObj<HealthQuoteResult> products = ObjectMapperUtil.getObjectMapper().readValue(productXml, new TypeReference<PricesObj<HealthQuoteResult>>() {});

                Optional<HealthQuoteResult> productForApply = products.getPrice().stream().findFirst();

                productForApply.ifPresent(p -> {
                    if (!productId.equals(p.getProductId())) {
                        LOGGER.warn(String.format("Unexpected productId found for apply. TransactionId: '%1$s', expectedProductId (from health request): '%2$s', actualProductId (from database): '%3$s'", transactionId, productId, p.getProductId()));
                    }
                });

                if (!productForApply.isPresent()) {
                    throw new IllegalStateException(String.format("Unable to retrieve a single selected product for transactionId: '%1$s', productId: '%2$s'", transactionId, productId));
                }

                selectedProduct = productForApply.get();
            } catch (Exception ex) {
                LOGGER.error(String.format("Failed to retrieve selected product - %1$s", ex.getMessage()), ex);
                throw ex;
            }

            // Version 2
            final ApplicationOutgoingRequest<HealthApplicationRequest> request = ApplicationOutgoingRequest.<HealthApplicationRequest>newBuilder()
                    .transactionId(transactionId)
                    .brandCode(brand.getCode())
                    .requestAt(data.getRequestAt())
                    .providerFilter(data.getQuote().getApplication().getProvider())
                    .payload(RequestAdapterV2.adapt(data, selectedProduct, operator, cid, trialCampaign))
                    .sessionId(anonymousId)
                    .userId(userId)
                    .build();

            // Getting RootId from the transactionId
            final long rootId = transactionDao.getRootIdOfTransactionId(data.getTransactionId());
            LOGGER.debug("Getting {} from {}", kv("rootId", rootId), kv("transactionId", data.getTransactionId()));

            return clientV2Application.post(RestSettings.<ApplicationOutgoingRequest<HealthApplicationRequest>>builder()
                    .request(request)
                    .header("rootId", Long.toString(rootId))
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/apply")
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
        return Optional.ofNullable(data)
                .map(HealthRequest::getQuote)
                .map(HealthQuote::getTracking)
                .map(Tracking::getCid)
                .orElse(null);
    }

    private String getTrialCampaignFromData(HealthRequest data) {
        return Optional.ofNullable(data)
                .map(HealthRequest::getQuote)
                .map(HealthQuote::getSimples)
                .map(Simples::getContactTypeRadio)
                .orElse(null);
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
