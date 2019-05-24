package com.ctm.web.travel.quote.model;

import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.quote.model.request.PolicyType;
import com.ctm.web.travel.quote.model.request.SingleTripDetails;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;

import java.util.ArrayList;

import static com.ctm.web.core.utils.common.utils.LocalDateUtils.parseAUSLocalDate;

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

        // Convert front end quote request to travel-quote request
        TravelQuoteRequest quoteRequest = new TravelQuoteRequest();

        quoteRequest.setTravellersAge(quote.getTravellers().getTravellersAge());
        quoteRequest.setNumberOfAdults(quote.getAdults());
        quoteRequest.setNumberOfChildren(quote.getChildren());
        quoteRequest.setPreExistingMedicalCondition(quote.getPreExistingMedicalCondition());

        if(quote.getPolicyType().equals("S")){
            quoteRequest.setPolicyType(PolicyType.SINGLE);
            SingleTripDetails details = new SingleTripDetails();
            details.setDestinations(quote.getDestinations());

            details.setToDate(parseAUSLocalDate(quote.getDates().getToDate()));
            details.setFromDate(parseAUSLocalDate(quote.getDates().getFromDate()));

            quoteRequest.setSingleTripDetails(details);

        }else{
            quoteRequest.setPolicyType(PolicyType.MULTI);
        }

        if(quote.getFilter().getSingleProvider() != null && !quote.getFilter().getSingleProvider().equals("")){
            quoteRequest.setProviderFilter(new ArrayList<>());
            quoteRequest.getProviderFilter().add(quote.getFilter().getSingleProvider());
        }

        if(quote.getRenderingMode() != null && quote.getRenderingMode().equalsIgnoreCase("XS")){
            quoteRequest.setMobileUrls(true);
        }
        quoteRequest.setFirstName(quote.getFirstName());
        quoteRequest.setLastName(quote.getSurname());
        return quoteRequest;

    }

}
