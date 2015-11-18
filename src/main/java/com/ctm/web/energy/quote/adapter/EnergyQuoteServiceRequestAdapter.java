package com.ctm.web.energy.quote.adapter;

import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.quote.model.EnergyQuoteRequest;


public class EnergyQuoteServiceRequestAdapter implements WebRequestAdapter<EnergyResultsWebRequest,EnergyQuoteRequest> {

    @Override
    public EnergyQuoteRequest adapt(EnergyResultsWebRequest request) {
        EnergyQuoteRequest quoteRequest = new EnergyQuoteRequest();
        return quoteRequest;
    }

}
