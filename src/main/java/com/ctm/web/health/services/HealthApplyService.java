package com.ctm.web.health.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.schema.health.v1_0_0.ApplyRequest;
import com.ctm.schema.health.v1_0_0.ApplyResponse;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.resultsData.PricesObj;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.apply.model.RequestAdapter;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.apply.model.response.ResponseAdapter;
import com.ctm.web.health.exceptions.HealthApplyServiceException;
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
    private Client<ApplyRequest, ApplyResponse> clientV2Application;

    @Autowired
    private TransactionDao transactionDao;

    @Autowired
    private SessionDataServiceBean sessionDataServiceBean;

    @Autowired
    private HealthSelectedProductService healthSelectedProductService;

    @Autowired
    public HealthApplyService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
    }

    public HealthApplyResponse apply(HttpServletRequest httpServletRequest, Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException, HealthApplyServiceException {

        LOGGER.info("Calling HealthApplyService.apply");

        final QuoteServiceProperties properties = getQuoteServiceProperties("atlasApplyService", brand, HEALTH.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        Long transactionId = data.getTransactionId(); // transactionId cannot be null.

        // The two IDs below gets populated by the AuthenticationFilter, which extracts them from the relevant JWT token
        final String anonymousId = Optional.ofNullable(httpServletRequest.getAttribute(TOKEN_REQUEST_PARAM_ANONYMOUS_ID)).map(Object::toString).orElse(null);
        final String userId = Optional.ofNullable(httpServletRequest.getAttribute(TOKEN_REQUEST_PARAM_USER_ID)).map(Object::toString).orElse(null);

        if (anonymousId != null || userId != null) {
            // Removed as change is from Jun'19 but DB changes only exist in NXI and no migration script was ever prepared
            // Issues have never been reported so assumed it's not essential but will leave here for historical purposes.
            //transactionDao.writeAuthIDs(transactionId, anonymousId, userId);
        }

        String operator = null;
        String trialCampaign = getTrialCampaignFromData(data);
        String cid = getCidFromData(data);
        AuthenticatedData authenticatedSessionData = sessionDataServiceBean.getAuthenticatedSessionData(httpServletRequest);
        if (authenticatedSessionData != null) {
            operator = authenticatedSessionData.getUid();
        }
        LOGGER.info("Found {}, {}, {} from {}", kv("operator", operator), kv("cid", cid), kv("trialCampaign", trialCampaign), kv("transactionId", transactionId));

        final HealthQuoteResult selectedProduct;

        String productId;
        try {
            productId = HealthRequestParser.getProductIdFromHealthRequest(data);
            LOGGER.info(String.format("productId retrieved from health request: transactionId %1$s, productId %2$s.", transactionId, productId));
        } catch (Exception e) {
            String errorCopy = String.format("Exception (%1$s) retrieving productId from health-request with message: %2$s", e.getClass(), e.getMessage());
            LOGGER.error(errorCopy, e);
            throw new HealthApplyServiceException(errorCopy);
        }

        String productXml;
        try {
            productXml = healthSelectedProductService.getProductXML(transactionId, productId);
        } catch (Exception e) {
            String errorCopy = String.format("Exception (%1$s) retrieving productXML with message: %2$s", e.getClass(), e.getMessage());
            LOGGER.error(errorCopy, e);
            throw new HealthApplyServiceException(errorCopy);
        }

        final PricesObj<HealthQuoteResult> products;
        try {
            products = ObjectMapperUtil.getObjectMapper().readValue(productXml, new TypeReference<PricesObj<HealthQuoteResult>>() {
            });
        } catch (Exception e) {
            String errorCopy = String.format("Exception (%1$s) retrieving products list from productXML with message: %2$s", e.getClass(), e.getMessage());
            LOGGER.error(errorCopy, e);
            throw new HealthApplyServiceException(errorCopy);
        }

        final Optional<HealthQuoteResult> productForApply;
        try {
            productForApply = products.getPrice().stream().findFirst();
        } catch (Exception e) {
            String errorCopy = String.format("Exception (%1$s) retrieving first product from product list with message: %2$s", e.getClass(), e.getMessage());
            LOGGER.error(errorCopy, e);
            throw new HealthApplyServiceException(errorCopy);
        }

        productForApply.ifPresent(p -> {
            if (!productId.equals(p.getProductId())) {
                LOGGER.error(String.format("Unexpected productId found for apply. TransactionId: '%1$s', expectedProductId (from health request): '%2$s', actualProductId (from database): '%3$s'", transactionId, productId, p.getProductId()));
            } else {
                LOGGER.info(String.format("Retrieved productId of product matches that from original request. TransactionId: '%1$s', expectedProductId (from health request): '%2$s', actualProductId (from database): '%3$s'", transactionId, productId, p.getProductId()));
            }
        });

        if (!productForApply.isPresent()) {
            String errorCopy = String.format("Unable to retrieve a single selected product for transactionId: '%1$s', productId: '%2$s'", transactionId, productId);
            LOGGER.error(errorCopy);
            throw new HealthApplyServiceException(errorCopy);
        }

        selectedProduct = productForApply.get();

        // Schematic ApplyRequest
        final ApplyRequest applyRequest;
        try {
            applyRequest = RequestAdapter.adapt(data, selectedProduct, operator, cid, trialCampaign, brand.getCode());
        } catch (Exception e) {
            String errorCopy = String.format("Exception %1$s adapting request to Schematic ApplyRequest with message: %2$s.", e.getClass(), e.getMessage());
            LOGGER.error(errorCopy, e);
            throw new HealthApplyServiceException(errorCopy);
        }

        // Getting RootId from the transactionId
        final long rootId;
        try {
            rootId = transactionDao.getRootIdOfTransactionId(transactionId);
            LOGGER.info(String.format("Successfully retrieved the RootId (%1$s) using TransactionId (%2$s).", rootId, transactionId));
        } catch (Exception e) {
            String errorCopy = String.format("Exception %1$s getting RootID from the TransactionID (%2$s) with message: %3$s.", e.getClass(), transactionId, e.getMessage());
            LOGGER.error(errorCopy, e);
            throw new HealthApplyServiceException(errorCopy);
        }

        final ApplyResponse schematicApplyResponse = clientV2Application.post(RestSettings.<ApplyRequest>builder()
                        .request(applyRequest)
                        .header("rootId", Long.toString(rootId))
                        .jsonHeaders()
//                ToDo SML-2413 apply service is hard coded to connect Atlas apply-health service which was created for testing
//                  SML-2413. This MUST be revert before merging into master
                        .url("https://services.dev.comparethemarket.cloud/apply-health/")
                        .timeout(properties.getTimeout())
                        .responseType(MediaType.APPLICATION_JSON)
                        .response(ApplyResponse.class)
                        .build())
                .doOnError(this::logHttpClientError)
                .observeOn(Schedulers.io()).toBlocking().single();

        return ResponseAdapter.adapt(transactionId, schematicApplyResponse);
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

}
