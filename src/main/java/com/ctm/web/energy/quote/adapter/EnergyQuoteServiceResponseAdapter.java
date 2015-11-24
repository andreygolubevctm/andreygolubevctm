package com.ctm.web.energy.quote.adapter;

import com.ctm.energy.quote.response.model.EnergyQuote;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.energy.form.response.model.EnergyResultsWebResponse;


public class EnergyQuoteServiceResponseAdapter implements WebResponseAdapter<EnergyResultsWebResponse, Response<EnergyQuote>> {

    @Override
    public EnergyResultsWebResponse adapt(Response<EnergyQuote> request) {
        return null;
    }
}
