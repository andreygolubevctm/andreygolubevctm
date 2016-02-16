package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import com.ctm.web.life.adapter.LifeServiceRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.form.model.Applicant;
import com.ctm.web.life.form.model.LifeQuote;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class LifeBrokerApplyServiceRequestAdapter implements WebRequestAdapter<LifeApplyWebRequest, LifeBrokerApplyRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeBrokerApplyServiceRequestAdapter.class);
    private final LifeQuote lifeQuoteRequest;

    public LifeBrokerApplyServiceRequestAdapter(LifeQuote lifeQuoteRequest) {
        this.lifeQuoteRequest = lifeQuoteRequest;
    }

    @Override
    public LifeBrokerApplyRequest adapt(LifeApplyWebRequest energyApplyPostRequestPayload) {
        LOGGER.debug("energyApplyPostRequestPayload = {}", kv("payload", energyApplyPostRequestPayload));

        Applicant primary = lifeQuoteRequest.getPrimary();
        // Map LifeBrokerApplyRequest
        LifeBrokerApplyRequest.Builder lifeBrokerApplyRequestBuilder = new LifeBrokerApplyRequest.Builder();
        lifeBrokerApplyRequestBuilder
                .applicants(LifeServiceRequestAdapter
                        .getApplicants(primary, lifeQuoteRequest.getPartner()));
        lifeBrokerApplyRequestBuilder
                .contactDetails(LifeServiceRequestAdapter
                        .createContactDetails(lifeQuoteRequest.getContactDetails(), primary));
        lifeBrokerApplyRequestBuilder.partnerProductId(energyApplyPostRequestPayload.getPartner_product_id());

        return lifeBrokerApplyRequestBuilder.build();
    }

    public String getProductId(LifeApplyWebRequest model) {
        return model.getClient_product_id();
    }

}
