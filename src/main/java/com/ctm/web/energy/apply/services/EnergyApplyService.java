package com.ctm.web.energy.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.interfaces.common.types.Status;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.providers.model.ApplyResponseImpl;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.TouchService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceRequestAdapter;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceResponseAdapter;
import com.ctm.web.energy.apply.exceptions.FailedToRegisterException;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Component
public class EnergyApplyService extends CommonRequestService<EnergyApplicationDetails,ApplyResponseImpl> {

    @Autowired
    private EnergyApplyConfirmation energyApplyConfirmation;

    @Autowired
    TouchService touchService;

    @Autowired
    TransactionDao transactionDao;

    @Autowired
    public EnergyApplyService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }


    public EnergyApplyWebResponseModel apply(EnergyApplyPostRequestPayload model, Brand brand, HttpServletRequest request) throws IOException, DaoException, ServiceConfigurationException {
        EnergyApplyServiceResponseAdapter responseAdapter= new EnergyApplyServiceResponseAdapter();
        EnergyApplyServiceRequestAdapter requestAdapter = new EnergyApplyServiceRequestAdapter();
        final EnergyApplicationDetails energyApplicationDetails = requestAdapter.adapt(model);
        ApplyResponse applyResponse = sendApplyRequest(brand, Vertical.VerticalType.ENERGY, "applyServiceBER", Endpoint.APPLY, model, energyApplicationDetails,
                ApplyResponseImpl.class, requestAdapter.getProductId(model));
        if(Status.REGISTERED.equals(applyResponse.getResponseStatus())) {
            long transactionId=  model.getTransactionId();
            String confirmationkey = energyApplyConfirmation.createAndSaveConfirmation(request.getSession().getId(), model, applyResponse, requestAdapter);
            writeSoldTouchToRootId(transactionId);
            writeSoldTouch(transactionId);
            return responseAdapter.adapt(applyResponse)
                    .transactionId(model.getTransactionId())
                    .confirmationkey(confirmationkey).build();
        } else {
            throw new FailedToRegisterException(applyResponse, model.getTransactionId());
        }
	}

    private void writeSoldTouchToRootId(long transactionId) throws DaoException {
        //write touch to root id to stop lead feed cron sending lead
        long rootId = transactionDao.getRootIdOfTransactionId(transactionId);
        if(transactionId != rootId) {
            writeSoldTouch(rootId);
        }
    }

    private void writeSoldTouch(long rootId) {
        Touch touch = new Touch();
        touch.setType(Touch.TouchType.SOLD);
        touch.setTransactionId(rootId);
        touchService.recordTouch(touch);
    }
}
