package com.ctm.web.life.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.interfaces.common.types.Status;
import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.core.apply.exceptions.FailedToRegisterException;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.utils.LeadFeed;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.services.*;
import com.ctm.web.core.web.DataParser;
import com.ctm.web.core.web.go.Data;
import com.ctm.interfaces.common.types.PartnerError;
import com.ctm.web.life.apply.adapter.LifeApplyServiceResponseAdapter;
import com.ctm.web.life.apply.adapter.LifeBrokerApplyServiceRequestAdapter;
import com.ctm.web.life.apply.adapter.OzicareApplyServiceRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.apply.response.LifeApplyWebResponse;
import com.ctm.web.life.apply.response.LifeApplyWebResponseResults;
import com.ctm.web.life.form.model.LifeQuote;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class LifeApplyService extends CommonRequestService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeApplyService.class);

    @Autowired
    private final SessionDataServiceBean sessionDataService;
    private final LifeApplyCompleteService lifeApplyCompleteService;
    private final LeadFeed leadFeed;


    @Autowired
    public LifeApplyService(ProviderFilterDao providerFilterDAO, RestClient restClient,
                            SessionDataServiceBean sessionDataService,
                            ServiceConfigurationService serviceConfigurationService,
                            @Qualifier("environmentBean") EnvironmentService.Environment  environment,
                            LifeApplyCompleteService lifeApplyCompleteService,
                            LeadFeed leadFeed) {
        super(providerFilterDAO, restClient, serviceConfigurationService, environment);
        this.sessionDataService = sessionDataService;
        this.lifeApplyCompleteService = lifeApplyCompleteService;
        this.leadFeed = leadFeed;
    }


    public LifeApplyWebResponse apply(LifeApplyWebRequest model, Brand brand, HttpServletRequest request) throws
            ServiceException {
        LifeApplyServiceResponseAdapter responseAdapter= new LifeApplyServiceResponseAdapter();
        LifeQuote lifeQuoteRequest;
        try {
            lifeQuoteRequest = DataParser.createObjectFromData(getData( request, model.getTransactionId()), LifeQuote.class, model.getVertical());
        } catch (SessionException e) {
            throw new ServiceException("Could not get data from session", e);
        }

        LifeBrokerApplyServiceRequestAdapter lifeBrokeRequestAdapter= new LifeBrokerApplyServiceRequestAdapter(lifeQuoteRequest);
        OzicareApplyServiceRequestAdapter requestAdapter = new OzicareApplyServiceRequestAdapter(lifeQuoteRequest);
        final Object applyRequest;

        String endpoint =  Endpoint.APPLY.getValue();
        boolean isOzicare = StringUtils.equalsIgnoreCase("Ozicare" , model.getCompany());
        if(isOzicare){
            endpoint += OzicareApplyRequest.PATH;
            applyRequest = requestAdapter.adapt(model);
        } else {
            endpoint += LifeBrokerApplyRequest.PATH;
            applyRequest = lifeBrokeRequestAdapter.adapt(model);
        }
        LifeApplyResponse applyResponse = submit(model, brand, requestAdapter, applyRequest, endpoint, isOzicare);
        LifeApplyWebResponseResults.Builder responseBuilder = responseAdapter.adapt(applyResponse);
        responseBuilder.transactionId(model.getTransactionId());
        lifeApplyCompleteService.handleSuccess(model.getTransactionId(), request,
                requestAdapter.getEmailAddress(lifeQuoteRequest), requestAdapter.getProductId(model), applyResponse,
                isOzicare);
        return new LifeApplyWebResponse.Builder().results(responseBuilder.build()).build();
	}

    public LifeApplyResponse submit(LifeApplyWebRequest model, Brand brand, OzicareApplyServiceRequestAdapter requestAdapter, Object applyRequest,
                                    String endpoint, boolean isOzicare) throws ServiceException {
        LifeApplyResponse applyResponse;
        boolean isTest = false;
        try {
            isTest = leadFeed.isTestOnlyLead(requestAdapter.getPhoneNumber(),
                    brand,
                    Vertical.VerticalType.LIFE,
                    new Date());
        } catch (LeadFeedException e) {
            LOGGER.error("failed to check if request is test", e);
        }
        if(!isOzicare || !isTest) {
             applyResponse = sendApplyRequest(brand, Vertical.VerticalType.LIFE, "applyServiceBER", endpoint, model, applyRequest,
                    LifeApplyResponse.class, requestAdapter.getProductId(model));
        } else {
            applyResponse = new LifeApplyResponse.Builder().responseStatus(Status.REGISTERED).build();
        }
        return applyResponse;
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

    public ErrorInfo mapException(FailedToRegisterException e) {
        ErrorInfo errorInfo = new ErrorInfo();
        errorInfo.setTransactionId(e.getTransactionId());
        ApplyResponse response = e.getApplyResponse();
        if(response != null) {
            List<PartnerError> errors = response.getPartnerErrorList();
            Map<String, String> errorMap = new HashMap<>();
            for (PartnerError error : errors) {
                errorMap.put(error.getCode().get().orElse("Unknown Code"), error.getMessage().get().orElse(""));
            }
            errorInfo.setErrors(errorMap);
        }
        return errorInfo;
    }
}
