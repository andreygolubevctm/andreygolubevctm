package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.form.model.LifeQuote;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class OzicareApplyServiceRequestAdapter implements WebRequestAdapter<LifeApplyWebRequest, OzicareApplyRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(OzicareApplyServiceRequestAdapter.class);
    private final LifeQuote lifeQuoteRequest;

    public OzicareApplyServiceRequestAdapter(LifeQuote lifeQuoteRequest) {
        this.lifeQuoteRequest = lifeQuoteRequest;
    }

    @Override
    public OzicareApplyRequest adapt(LifeApplyWebRequest requestPayload) {
        LOGGER.debug("requestPayload = {}", kv("payload", requestPayload));

        OzicareApplyRequest.Builder ozicareApplyRequestBuilder = OzicareApplyRequest.newBuilder();

        ozicareApplyRequestBuilder.state(lifeQuoteRequest.getPrimary().getState());
        ozicareApplyRequestBuilder.phoneNumber(getPhoneNumber());
        ozicareApplyRequestBuilder.firstName(lifeQuoteRequest.getPrimary().getFirstName());
        ozicareApplyRequestBuilder.lastName(lifeQuoteRequest.getPrimary().getLastname());
        ozicareApplyRequestBuilder.leadNumber(requestPayload.getLead_number());


        OzicareApplyRequest ozicareApplyRequest = ozicareApplyRequestBuilder.build();
        LOGGER.debug("energyApplicationDetails={}", kv("details", ozicareApplyRequest));

        return ozicareApplyRequest;
    }

    public String getProductId(LifeApplyWebRequest requestPayload) {
        return requestPayload.getClient_product_id();
    }

    public String getEmailAddress(LifeQuote lifeQuoteRequest) {
        return lifeQuoteRequest.getContactDetails().getEmail();
    }

    public String getPhoneNumber() {
        return lifeQuoteRequest.getContactDetails().getContactNumber();
    }
}
