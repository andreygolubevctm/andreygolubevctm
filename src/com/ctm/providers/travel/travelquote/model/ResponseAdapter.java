package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.AvailableType;
import com.ctm.model.travel.TravelResult;
import com.ctm.providers.QuoteResponse;
import com.ctm.providers.travel.travelquote.model.response.TravelQuote;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;

import java.util.ArrayList;
import java.util.List;

public class ResponseAdapter {

    /**
     * Trave-quote to web_ctm adapter
     * Take response from travel-quote and convert it to a java model to be returned to the front end.
     *
     * @param response
     * @return
     */
    public static List<TravelResult> adapt(TravelResponse response) {

        List<TravelResult> results = new ArrayList<>();
        final QuoteResponse<TravelQuote> quoteResponse = response.getPayload();
        if (quoteResponse != null) {
            for (TravelQuote travelQuote : quoteResponse.getQuotes()) {
                TravelResult result = new TravelResult();
                result.setAvailable(travelQuote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setServiceName(travelQuote.getService());

                // TODO Complete adapter

                results.add(result);
            }

        }

        return results;
    }
}
