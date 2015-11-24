package com.ctm.web.travel.quote.model;

import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.quote.model.request.PolicyType;
import com.ctm.web.travel.quote.model.request.SingleTripDetails;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class RequestAdapter {
    private static final Logger LOGGER = LoggerFactory.getLogger(RequestAdapter.class);

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

        // Convert front end quote request to travel-quote request
        TravelQuoteRequest quoteRequest = new TravelQuoteRequest();

        quoteRequest.setTravellersDOB(quote.getTravellers().getTravellersDOB());
        quoteRequest.setNumberOfAdults(quote.getAdults());
        quoteRequest.setNumberOfChildren(quote.getChildren());

        if(quote.getPolicyType().equals("S")){
            quoteRequest.setPolicyType(PolicyType.SINGLE);
            SingleTripDetails details = new SingleTripDetails();
            details.setDestinations(quote.getDestinations());

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            try {
                details.setToDate(LocalDate.parse(quote.getDates().getToDate(), dateFormatter));
                details.setFromDate(LocalDate.parse(quote.getDates().getFromDate(), dateFormatter));
            } catch (Exception e) {
                // TODO check this
                LOGGER.error("Failed to adapt front-end travel request to travel-quote request {}", kv("travelRequest", travelRequest));
            }

            quoteRequest.setSingleTripDetails(details);

        }else{
            quoteRequest.setPolicyType(PolicyType.MULTI);
        }

        if(quote.getFilter().getSingleProvider() != null && quote.getFilter().getSingleProvider().equals("") == false){
            quoteRequest.setProviderFilter(new ArrayList<>());
            quoteRequest.getProviderFilter().add(quote.getFilter().getSingleProvider());
        }

        if(quote.getRenderingMode() != null && quote.getRenderingMode().equalsIgnoreCase("XS")){
            quoteRequest.setMobileUrls(true);
        }

        return quoteRequest;

    }

}
