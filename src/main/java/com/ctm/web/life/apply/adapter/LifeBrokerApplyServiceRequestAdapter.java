package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.life.model.request.Gender;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.model.request.LifeRequest;
import com.ctm.web.life.model.request.Primary;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class LifeBrokerApplyServiceRequestAdapter implements WebRequestAdapter<LifeApplyPostRequestPayload, LifeBrokerApplyRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeBrokerApplyServiceRequestAdapter.class);
    private final LifeRequest lifeQuoteRequest;

    public LifeBrokerApplyServiceRequestAdapter(LifeRequest lifeQuoteRequest) {
        this.lifeQuoteRequest = lifeQuoteRequest;
    }

    @Override
    public LifeBrokerApplyRequest adapt(LifeApplyPostRequestPayload energyApplyPostRequestPayload) {
        LOGGER.debug("energyApplyPostRequestPayload = {}", kv("payload", energyApplyPostRequestPayload));

        Primary primary = lifeQuoteRequest.getPrimary();
        // Map LifeBrokerApplyRequest
        LifeBrokerApplyRequest.Builder lifeBrokerApplyRequestBuilder = new LifeBrokerApplyRequest.Builder();
        lifeBrokerApplyRequestBuilder
                .applicants(LifeBrokerServiceRequestAdapter
                        .getApplicants(primary, lifeQuoteRequest.getPartner()));
        lifeBrokerApplyRequestBuilder
                .contactDetails(LifeBrokerServiceRequestAdapter
                        .getContactDetails(lifeQuoteRequest.getContactDetails(), primary));
        lifeBrokerApplyRequestBuilder.partnerProductId(energyApplyPostRequestPayload.getPartner_product_id());

        return lifeBrokerApplyRequestBuilder.build();
    }

    private Gender adaptGender() {
        return lifeQuoteRequest.getPartner().getGender().equals(Gender.MALE) ? Gender.MALE : Gender.FEMALE;
    }

    public String getProductId(LifeApplyPostRequestPayload model) {
        return model.getClient_product_id();
    }

}
