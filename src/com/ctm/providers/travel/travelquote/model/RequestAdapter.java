package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.travel.form.TravelQuote;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;

/**
 * Created by twilson on 14/07/2015.
 */
public class RequestAdapter {

    public final static TravelQuoteRequest adapt(TravelQuote quote){

        TravelQuoteRequest quoteRequest = new TravelQuoteRequest();

        return quoteRequest;

    }
}
