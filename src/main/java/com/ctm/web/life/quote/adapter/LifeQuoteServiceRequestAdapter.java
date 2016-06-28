package com.ctm.web.life.quote.adapter;

import com.ctm.life.quote.model.request.LifeQuoteRequest;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import com.ctm.web.life.adapter.LifeServiceRequestAdapter;
import com.ctm.web.life.form.model.LifeQuote;
import com.ctm.web.life.form.model.LifeQuoteWebRequest;
import org.springframework.stereotype.Component;

@Component
public class LifeQuoteServiceRequestAdapter implements WebRequestAdapter<LifeQuoteWebRequest, LifeQuoteRequest> {

    @Override
    public LifeQuoteRequest adapt(LifeQuoteWebRequest request) {
        LifeQuote quote = request.getQuote();
        return LifeQuoteRequest.newBuilder()
                .applicants(LifeServiceRequestAdapter.getApplicants(quote.getPrimary(), quote.getPartner()))
                .contactDetails(LifeServiceRequestAdapter.createContactDetails(quote.getContactDetails(), quote.getPrimary()))
                .build();
    }




}
