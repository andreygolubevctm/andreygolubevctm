package com.ctm.web.energy.quote.adapter;

import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.quote.model.EnergyQuoteRequest;


public class EnergyQuoteServiceRequestMapper implements WebRequestAdapter<EnergyResultsWebRequest, EnergyQuoteRequest> {

    @Override
    public EnergyQuoteRequest adapt(EnergyResultsWebRequest request) {
        return null;
    }
}
