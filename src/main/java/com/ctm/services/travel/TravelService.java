package com.ctm.services.travel;

import com.ctm.model.results.ResultProperty;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.model.travel.form.TravelQuote;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.travel.travelquote.model.RequestAdapter;
import com.ctm.providers.travel.travelquote.model.ResponseAdapter;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;
import com.ctm.services.CommonQuoteService;
import com.ctm.services.ResultsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

public class TravelService extends CommonQuoteService<TravelQuote, TravelQuoteRequest, TravelResponse> {

	private static final Logger LOGGER = LoggerFactory.getLogger(TravelService.class);
    /**
     * Call travel-quote aggregation service.
     *
     * @param brand
     * @param data
     * @return
     */
    public List<TravelResult> getQuotes(Brand brand, com.ctm.model.travel.form.TravelRequest data) throws Exception {

        // Get quote from Form Request
        final TravelQuote quote = data.getQuote();

        setFilter(quote.getFilter());

        // Convert post data from form into a Travel-quote request
        final TravelQuoteRequest travelQuoteRequest = RequestAdapter.adapt(data);

        TravelResponse travelResponse = sendRequest(brand, Vertical.VerticalType.TRAVEL, "travelQuoteService", "TRAVEL-QUOTE", "quote",
                data, travelQuoteRequest, TravelResponse.class);

        // Convert travel-quote java model to front end model ready for JSON conversion to the front end.
        final List<TravelResult> travelResults = ResponseAdapter.adapt(travelQuoteRequest, travelResponse);

        List<ResultProperty> resultProperties = new ArrayList<>();
        for (TravelResult result : travelResults) {
            if (AvailableType.Y.equals(result.getAvailable())) {

                ResultPropertiesBuilder builder = new ResultPropertiesBuilder(
                        data.getTransactionId(), result.getProductId());
                builder.addResult("quoteUrl", result.getQuoteUrl());
                resultProperties.addAll(builder.getResultProperties());

            }
        }

        ResultsService.saveResultsProperties(resultProperties);

        return travelResults;

    }

}
