package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.travel.form.TravelQuote;
import com.ctm.model.travel.form.TravelRequest;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;


public class RequestAdapter {

    public final static TravelQuoteRequest adapt(TravelRequest travelRequest){

        // Retrieve quote as submitted from front end
        final TravelQuote quote = travelRequest.getQuote();

        // TODO check date format

        // Convert front end quote request to travel-quote request
        TravelQuoteRequest quoteRequest = new TravelQuoteRequest();

        quoteRequest.setDetinations(quote.getDestinations());
        quoteRequest.setFromDate(quote.getFromDate());
        quoteRequest.setNumberOfAdults(quote.getNumberOfAdults());
        quoteRequest.setNumerOfChildren(quote.getNumberOfChildren());
        quoteRequest.setOldestPerson(quote.getOldestPerson());
        quoteRequest.setPolicyType(quote.getPolicyType());
        quoteRequest.setToDate(quote.getToDate());
        quoteRequest.setProviderFilter(quote.getProviderFilter());
        quoteRequest.setMobileUrls(quote.getMobileUrls());

        return quoteRequest;

    }
}
