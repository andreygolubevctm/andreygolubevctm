package com.ctm.web.life.apply.services;

import com.ctm.apply.model.request.ApplyRequest;
import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.core.dao.ProviderFilterDao;
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
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.apply.response.LifeApplyWebResponseModel;
import com.ctm.web.life.form.model.LifeQuote;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Component
public class LifeApplyService extends CommonRequestService {

    private final SessionDataServiceBean sessionDataService;

    @Autowired
    public LifeApplyService(ProviderFilterDao providerFilterDAO, RestClient restClient,
                            SessionDataServiceBean sessionDataService,
                            ServiceConfigurationService serviceConfigurationService, @Qualifier("environmentBean") EnvironmentService.Environment  environment) {
        super(providerFilterDAO, restClient, serviceConfigurationService, environment);
        this.sessionDataService = sessionDataService;
    }


    public LifeApplyWebResponseModel apply(LifeApplyPostRequestPayload model, Brand brand, HttpServletRequest request) throws
            IOException,
            DaoException,
            ServiceConfigurationException,
            SessionException {
        LifeApplyServiceResponseAdapter responseAdapter= new LifeApplyServiceResponseAdapter();
        LifeQuote lifeQuoteRequest = DataParser.createObjectFromData(getData( request, model.getTransactionId()), LifeQuote.class, model.getVertical());

        LifeBrokerApplyServiceRequestAdapter lifeBrokeRequestAdapter= new LifeBrokerApplyServiceRequestAdapter(lifeQuoteRequest);
        OzicareApplyServiceRequestAdapter requestAdapter = new OzicareApplyServiceRequestAdapter(lifeQuoteRequest);
        final ApplyRequest.Builder<?>  applyRequestB;

    String endpoint;
        if("ozicare".equals(model.getCompany())){
            endpoint = "ozicare/" + Endpoint.APPLY;
            OzicareApplyRequest ozicareRequest = requestAdapter.adapt(model);
            ApplyRequest.Builder<OzicareApplyRequest> requestBuilder= new ApplyRequest.Builder<>();
            requestBuilder.payload(ozicareRequest);
            applyRequestB = requestBuilder;
        } else {
            endpoint = "lifebroker/" + Endpoint.APPLY;
            LifeBrokerApplyRequest lifeBrokerApplyRequest = lifeBrokeRequestAdapter.adapt(model);
            ApplyRequest.Builder<LifeBrokerApplyRequest> requestBuilder= new ApplyRequest.Builder<>();
            requestBuilder.payload(lifeBrokerApplyRequest);
            applyRequestB = requestBuilder;
        }
        LifeApplyResponse applyResponse = sendApplyRequest(brand, Vertical.VerticalType.LIFE, "applyServiceBER", endpoint, model, applyRequestB.build(),
                LifeApplyResponse.class, requestAdapter.getProductId(model));
        LifeApplyWebResponseModel.Builder responseBuilder = responseAdapter.adapt(applyResponse);
        responseBuilder.transactionId(model.getTransactionId());
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
