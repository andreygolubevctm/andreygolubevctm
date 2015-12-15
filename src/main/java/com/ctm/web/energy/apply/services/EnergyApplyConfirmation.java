package com.ctm.web.energy.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.web.core.confirmation.model.Confirmation;
import com.ctm.web.core.confirmation.services.ConfirmationService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceRequestAdapter;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.apply.model.response.EnergyConfirmationData;
import com.ctm.web.energy.apply.model.response.ProductConfirmationData;
import com.ctm.web.energy.form.model.WhatToCompare;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class EnergyApplyConfirmation {

    private static final Logger LOGGER = LoggerFactory.getLogger(EnergyApplyService.class);

    @Autowired
    private ConfirmationService confirmationService;


    public String createAndSaveConfirmation(String sessionId, EnergyApplyPostRequestPayload model,
                                            ApplyResponse applyResponse, EnergyApplyServiceRequestAdapter requestAdapter) {
        long transactionId=  model.getTransactionId();
        final String confirmationId = sessionId + "-" + transactionId;
        try {

            final EnergyConfirmationData confirmationData = getEnergyConfirmationData(model, applyResponse, requestAdapter);

            Confirmation confirmation = new Confirmation();
            confirmation.setKey(confirmationId);
            confirmation.setTransactionId(transactionId);
            confirmation.setXmlData(ObjectMapperUtil.getXmlMapper().writeValueAsString(confirmationData));
            confirmationService.addConfirmation(confirmation);
        } catch (DaoException | JsonProcessingException e) {
            LOGGER.warn("Failed to add confirmation {}", kv("confirmationId", confirmationId), e);
            throw new RuntimeException(e);
        }
        return confirmationId;
    }

    private EnergyConfirmationData getEnergyConfirmationData(EnergyApplyPostRequestPayload model, ApplyResponse applyResponse, EnergyApplyServiceRequestAdapter requestAdapter) {
        ProductConfirmationData productConfirmationData = new ProductConfirmationData(requestAdapter.getProductId(model),
                requestAdapter.getRetailerName(model),
                requestAdapter.getPlanName(model));
        WhatToCompare whatToCompare = requestAdapter.getWhatToCompare(model);
        return new EnergyConfirmationData(requestAdapter.getFirstName(model),
                whatToCompare,
                applyResponse.getConfirmationId().get(),
                productConfirmationData);
    }

}
