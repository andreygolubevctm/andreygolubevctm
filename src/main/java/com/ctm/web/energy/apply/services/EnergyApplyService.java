package com.ctm.web.energy.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.interfaces.common.types.Status;
import com.ctm.web.core.confirmation.model.Confirmation;
import com.ctm.web.core.confirmation.services.ConfirmationService;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.TouchService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceRequestAdapter;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceResponseAdapter;
import com.ctm.web.energy.apply.exceptions.FailedToRegisterException;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.apply.model.request.Hidden;
import com.ctm.web.energy.apply.model.response.EnergyConfirmationData;
import com.ctm.web.energy.apply.model.response.ProductConfirmationData;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.ctm.web.energy.form.model.WhatToCompare;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class EnergyApplyService extends CommonRequestService<EnergyApplicationDetails,ApplyResponse> {

    private static final Logger LOGGER = LoggerFactory.getLogger(EnergyApplyService.class);

    @Autowired
    private ConfirmationService confirmationService;

    @Autowired
    TouchService touchService;

    @Autowired
    public EnergyApplyService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }


    public EnergyApplyWebResponseModel apply(EnergyApplyPostRequestPayload model, Brand brand, HttpServletRequest request) throws IOException, DaoException, ServiceConfigurationException {
        EnergyApplyServiceResponseAdapter responseAdapter= new EnergyApplyServiceResponseAdapter();
        EnergyApplyServiceRequestAdapter requestAdapter = new EnergyApplyServiceRequestAdapter();
        final EnergyApplicationDetails energyApplicationDetails = requestAdapter.adapt(model);
//        EnergyApplicationResponse energyApplicationResponseModel = sendRequest(brand, ENERGY, "applyServiceBER", Endpoint.APPLY, model, energyApplicationDetails,
//                EnergyApplicationResponse.class);

        ApplyResponse applyResponse = null;
        if(applyResponse.getResponseStatus().equals(Status.REGISTERED)) {
            String confirmationkey = createAndSaveConfirmation(request, model, applyResponse);
            return responseAdapter.adapt(applyResponse)
                    .transactionId(model.getTransactionId())
                    .confirmationkey(confirmationkey).build();
        } else {
            throw new FailedToRegisterException(applyResponse);
        }
	}

    private String createAndSaveConfirmation(HttpServletRequest request, EnergyApplyPostRequestPayload model, ApplyResponse applyResponse) {
        final String confirmationId = request.getSession().getId() + "-" + model.getTransactionId();
        try {

            Hidden hiddenProductDetails = model.getUtilities().getApplication().getThingsToKnow().getHidden();
            ProductConfirmationData productConfirmationData = new ProductConfirmationData(hiddenProductDetails.getProductId(), hiddenProductDetails.getRetailerName(), hiddenProductDetails.getPlanName());
            String firstName = model.getUtilities().getApplication().getDetails().getFirstName();
            WhatToCompare whatToCompare = model.getUtilities().getHouseholdDetails().getWhatToCompare();
            final EnergyConfirmationData confirmationData =  new EnergyConfirmationData(firstName,
                    whatToCompare,
                            applyResponse.getConfirmationId().get(),
                            productConfirmationData);

            Confirmation confirmation = new Confirmation();
            confirmation.setKey(confirmationId);
            confirmation.setTransactionId(model.getTransactionId());
            confirmation.setXmlData(ObjectMapperUtil.getXmlMapper().writeValueAsString(confirmationData));
            confirmationService.addConfirmation(confirmation);
            long rootId = model.getCurrent().getRootId();
            writeTouch(confirmation.getTransactionId());
            // used so lead feed won't pick this lead up
            if(confirmation.getTransactionId() != rootId) {
                writeTouch(rootId);
            }
        } catch (Exception e) {
            LOGGER.warn("Failed to add confirmation {}", kv("confirmationId", confirmationId), e);
            throw new RuntimeException(e);
        }
        return confirmationId;
    }

    private void writeTouch(long rootId) {
        Touch touch = new Touch();
        touch.setType(Touch.TouchType.SOLD);
        touch.setTransactionId(rootId);
        touchService.recordTouch(touch);
    }
}
