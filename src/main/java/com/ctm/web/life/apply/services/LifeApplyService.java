package com.ctm.web.life.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.apply.exceptions.FailedToRegisterException;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.SessionException;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class LifeApplyService extends CommonRequestService {

    @Autowired
    private final SessionDataServiceBean sessionDataService;
    private final LifeApplyCompleteService lifeApplyCompleteService;


    @Autowired
    public LifeApplyService(ProviderFilterDao providerFilterDAO, RestClient restClient,
                            SessionDataServiceBean sessionDataService,
                            ServiceConfigurationService serviceConfigurationService,
                            @Qualifier("environmentBean") EnvironmentService.Environment  environment,
                            LifeApplyCompleteService lifeApplyCompleteService) {
        super(providerFilterDAO, restClient, serviceConfigurationService, environment);
        this.sessionDataService = sessionDataService;
        this.lifeApplyCompleteService = lifeApplyCompleteService;
    }


    public LifeApplyWebResponse apply(LifeApplyWebRequest model, Brand brand, HttpServletRequest request) throws
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
        LifeApplyWebResponseResults.Builder responseBuilder = responseAdapter.adapt(applyResponse);
        responseBuilder.transactionId(model.getTransactionId());
        lifeApplyCompleteService.handleSuccess(model.getTransactionId(), request, requestAdapter.getEmailAddress(lifeQuoteRequest), requestAdapter.getProductId(model), applyResponse,
                model.getCompany());
        return new LifeApplyWebResponse.Builder().results(responseBuilder.build()).build();
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
