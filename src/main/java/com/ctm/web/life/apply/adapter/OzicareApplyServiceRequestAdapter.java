package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.model.request.LifeRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class OzicareApplyServiceRequestAdapter implements WebRequestAdapter<LifeApplyPostRequestPayload, OzicareApplyRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(OzicareApplyServiceRequestAdapter.class);
    private final LifeRequest lifeQuoteRequest;

    public OzicareApplyServiceRequestAdapter(LifeRequest lifeQuoteRequest) {
        this.lifeQuoteRequest = lifeQuoteRequest;
    }

    @Override
    public OzicareApplyRequest adapt(LifeApplyPostRequestPayload requestPayload) {
        LOGGER.debug("requestPayload = {}", kv("payload", requestPayload));

        // Map EnergyApplicationDetails
        OzicareApplyRequest.Builder ozicareApplyRequestBuilder = OzicareApplyRequest.newBuilder();

        ozicareApplyRequestBuilder.state(lifeQuoteRequest.getPrimary().getState());
        ozicareApplyRequestBuilder.phoneNumber(lifeQuoteRequest.getContactDetails().getContactNumber());
        ozicareApplyRequestBuilder.firstName(lifeQuoteRequest.getPrimary().getFirstName());
        ozicareApplyRequestBuilder.lastName(lifeQuoteRequest.getPrimary().getLastname());
        ozicareApplyRequestBuilder.productId(getProductId(requestPayload));


        OzicareApplyRequest ozicareApplyRequest = ozicareApplyRequestBuilder.build();
        LOGGER.debug("energyApplicationDetails={}", kv("details", ozicareApplyRequest));

        return ozicareApplyRequest;
    }

    public String getProductId(LifeApplyPostRequestPayload requestPayload) {
        return requestPayload.getClient_product_id();
    }

}
