package com.ctm.web.life.apply.services;

import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.*;
import com.ctm.web.core.web.DataParser;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.apply.adapter.LifeApplyServiceResponseAdapter;
import com.ctm.web.life.apply.adapter.LifeBrokerApplyServiceRequestAdapter;
import com.ctm.web.life.apply.adapter.OzicareApplyServiceRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.apply.response.LifeApplyWebResponseModel;
import com.ctm.web.life.form.model.LifeQuote;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class LifeApplyService extends CommonRequestService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeApplyService.class);

    private final SessionDataServiceBean sessionDataService;

    @Autowired
    private LifeSendEmailService lifeSendEmailService;

    @Autowired
    public LifeApplyService(ProviderFilterDao providerFilterDAO, RestClient restClient,
                            SessionDataServiceBean sessionDataService,
                            ServiceConfigurationService serviceConfigurationService, @Qualifier("environmentBean") EnvironmentService.Environment  environment) {
        super(providerFilterDAO, restClient, serviceConfigurationService, environment);
        this.sessionDataService = sessionDataService;
    }


    public LifeApplyWebResponseModel apply(LifeApplyWebRequest model, Brand brand, HttpServletRequest request) throws
            IOException,
            DaoException,
            ServiceConfigurationException,
            SessionException {
        LifeApplyServiceResponseAdapter responseAdapter= new LifeApplyServiceResponseAdapter();
        LifeQuote lifeQuoteRequest = DataParser.createObjectFromData(getData( request, model.getTransactionId()), LifeQuote.class, model.getVertical());

        LifeBrokerApplyServiceRequestAdapter lifeBrokeRequestAdapter= new LifeBrokerApplyServiceRequestAdapter(lifeQuoteRequest);
        OzicareApplyServiceRequestAdapter requestAdapter = new OzicareApplyServiceRequestAdapter(lifeQuoteRequest);
        final Object applyRequest;

        String endpoint =  Endpoint.APPLY.getValue();
        if("ozicare".equals(model.getCompany())){
            endpoint += OzicareApplyRequest.PATH;
            applyRequest = requestAdapter.adapt(model);
        } else {
            endpoint += LifeBrokerApplyRequest.PATH;
            applyRequest = lifeBrokeRequestAdapter.adapt(model);
        }
        LifeApplyResponse applyResponse = sendApplyRequest(brand, Vertical.VerticalType.LIFE, "applyServiceBER", endpoint, model, applyRequest,
                LifeApplyResponse.class, requestAdapter.getProductId(model));
        LifeApplyWebResponseModel.Builder responseBuilder = responseAdapter.adapt(applyResponse);
        responseBuilder.transactionId(model.getTransactionId());
        if("ozicare".equals(model.getCompany()) && com.ctm.interfaces.common.types.Status.REGISTERED.equals(applyResponse.getResponseStatus())){
            try {
                lifeSendEmailService.sendEmail(model.getTransactionId(),requestAdapter.getEmailAddress(lifeQuoteRequest), request);
            } catch (SendEmailException e) {
                LOGGER.error("Failed to send ozicare emails {}" ,kv("emailAddress",requestAdapter.getEmailAddress(lifeQuoteRequest)), e);
            }
        }
        return responseBuilder.build();
	}

    /**
     * Retrieve the current sessions data bucket
     */
    private Data getData(HttpServletRequest request, long transactionId) throws SessionException {
        SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
        if (sessionData == null) {
            throw new SessionException("session has expired");
        }
        return sessionData.getSessionDataForTransactionId(transactionId);
    }

}
