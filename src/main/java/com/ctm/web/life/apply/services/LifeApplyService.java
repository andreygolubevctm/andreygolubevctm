package com.ctm.web.life.apply.services;

import com.ctm.apply.model.request.ApplyRequest;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.web.DataParser;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.apply.adapter.LifeApplyServiceResponseAdapter;
import com.ctm.web.life.apply.adapter.LifeBrokerApplyServiceRequestAdapter;
import com.ctm.web.life.apply.adapter.OzicareApplyServiceRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.apply.response.LifeApplyWebResponseModel;
import com.ctm.web.life.form.model.LifeQuote;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Component
public class LifeApplyService extends CommonRequestService {

    @Autowired
    SessionDataServiceBean sessionDataService;

    @Autowired
    public LifeApplyService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
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
        final ApplyRequest energyApplicationDetails;

/*    String endpoint;
        if("ozicare".equals(model.getCompany())){
            endpoint = "ozicare/" + Endpoint.APPLY;
            energyApplicationDetails = requestAdapter.adapt(model);
        } else {
            endpoint = "lifebroker/" + Endpoint.APPLY;
            className = SingleApplyResponse.class;
            energyApplicationDetails = lifeBrokeRequestAdapter.adapt(model);
        }
        ApplyResponse applyResponse = sendApplyRequest(brand, Vertical.VerticalType.LIFE, "applyServiceBER", endpoint, model, energyApplicationDetails,
                SingleApplyResponse.class, requestAdapter.getProductId(model));
        if(Status.REGISTERED.equals(applyResponse.getResponseStatus())) {
            String confirmationKey = energyApplyConfirmation.createAndSaveConfirmation(request.getSession().getId(), model, applyResponse, requestAdapter);
            return responseAdapter.adapt(applyResponse)
                    .transactionId(model.getTransactionId())
                    .confirmationkey(confirmationKey).build();
        } else {
            throw new FailedToRegisterException(applyResponse, model.getTransactionId());
        }*/
        LifeApplyResponse applyResponse = null;
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
