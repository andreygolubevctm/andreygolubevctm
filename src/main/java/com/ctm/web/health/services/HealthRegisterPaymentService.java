package com.ctm.web.health.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.GenericOutgoingRequest;
import com.ctm.web.core.providers.model.Request;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.health.model.form.HealthRegisterPaymentRequest;
import com.ctm.web.health.model.results.HealthRegisterPaymentResult;
import com.ctm.web.health.payment.register.model.RequestAdapter;
import com.ctm.web.health.payment.register.model.ResponseAdapter;
import com.ctm.web.health.payment.register.model.ResponseAdapterV2;
import com.ctm.web.health.payment.register.model.request.RegisterPaymentRequest;
import com.ctm.web.health.payment.register.model.response.RegisterPaymentResponse;
import com.ctm.web.health.payment.register.model.response.RegisterPaymentResponseV2;
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
public class HealthRegisterPaymentService extends CommonRequestServiceV2 {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthRegisterPaymentService.class);

    @Autowired
    private TransactionDao transactionDao;

    @Autowired
    private Client<Request<RegisterPaymentRequest>, RegisterPaymentResponse> client;

    @Autowired
    private Client<GenericOutgoingRequest<RegisterPaymentRequest>, RegisterPaymentResponseV2> clientV2;

    @Autowired
    private SessionDataServiceBean sessionDataServiceBean;

    @Autowired
    public HealthRegisterPaymentService(ProviderFilterDao providerFilterDao,
                                        ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDao, serviceConfigurationServiceBean);
    }

    public HealthRegisterPaymentResult register(HttpServletRequest httpServletRequest, Brand brand, HealthRegisterPaymentRequest data) throws DaoException, IOException, ServiceConfigurationException {

        final QuoteServiceProperties properties = getQuoteServiceProperties("healthApplyService", brand, HEALTH.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        final RegisterPaymentRequest payload = RequestAdapter.adapt(data);

        LOGGER.info("Calling health ipp register v2");

        String operator = null;
        AuthenticatedData authenticatedSessionData = sessionDataServiceBean.getAuthenticatedSessionData(httpServletRequest);
        if (authenticatedSessionData != null) {
            operator = authenticatedSessionData.getUid();
        }

        final GenericOutgoingRequest<RegisterPaymentRequest> request = GenericOutgoingRequest.<RegisterPaymentRequest>newBuilder()
                .transactionId(data.getTransactionId())
                .brandCode(brand.getCode())
                .requestAt(data.getRequestAt())
                .providerFilter(data.getProviderId())
                .payload(payload)
                .build();

        // Getting RootId from the transactionId
        final long rootId = transactionDao.getRootIdOfTransactionId(data.getTransactionId());
        LOGGER.debug("Getting {} from {}", kv("rootId", rootId), kv("transactionId", data.getTransactionId()));

        final RegisterPaymentResponseV2 response = clientV2.post(RestSettings.<GenericOutgoingRequest<RegisterPaymentRequest>>builder()
                        .request(request)
                        .header("rootId", Long.toString(rootId))
                        .header("operator", operator)
                        .jsonHeaders()
                        .url(properties.getServiceUrl() + "/payment/register")
                        .timeout(properties.getTimeout())
                        .responseType(MediaType.APPLICATION_JSON)
                        .response(RegisterPaymentResponseV2.class)
                        .build())
                .observeOn(Schedulers.io()).toBlocking().single();
        return ResponseAdapterV2.adapt(response);

    }

}