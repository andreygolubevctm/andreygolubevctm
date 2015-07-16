package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.travel.form.TravelQuote;
import com.ctm.model.travel.form.TravelRequest;
import com.ctm.providers.travel.travelquote.model.request.PolicyType;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;


public class RequestAdapter {

    /**
     * web_ctm to trave-quote adapter
     * Take request from the front-end and convert it to a java model to be sent to travel-quote.
     *
     * @param travelRequest
     * @return
     */
    public final static TravelQuoteRequest adapt(TravelRequest travelRequest){

        // Retrieve quote as submitted from front end
        final TravelQuote quote = travelRequest.getQuote();

        // TODO check date format

        // Convert front end quote request to travel-quote request
        TravelQuoteRequest quoteRequest = new TravelQuoteRequest(); // todo
/*

                PolicyType.SINGLE_TRIP, // todo
                quote.getNumberOfAdults(),
                quote.getNumberOfChildren(),
                quote.getOldestPerson(),
                null
 */

        return quoteRequest;

    }
}
