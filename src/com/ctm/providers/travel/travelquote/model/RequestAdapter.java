package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.travel.form.TravelQuote;
import com.ctm.model.travel.form.TravelRequest;
import com.ctm.providers.travel.travelquote.model.request.PolicyType;
import com.ctm.providers.travel.travelquote.model.request.SingleTripDetails;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.text.ParseException;
import java.text.SimpleDateFormat;


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

        quoteRequest.setOldestPerson(quote.getOldest());
        quoteRequest.setNumberOfAdults(quote.getAdults());
        quoteRequest.setNumberOfChildren(quote.getChildren());

        if(quote.getPolicyType().equals("S")){
            quoteRequest.setPolicyType(PolicyType.SINGLE);
            SingleTripDetails details = new SingleTripDetails();
            details.setDestinations(quote.getDestinations());

            SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy");

            try {
                details.setToDate(dateFormatter.parse(quote.getDates().getToDate()));
                details.setFromDate(dateFormatter.parse(quote.getDates().getFromDate()));
            } catch (ParseException e) {
                e.printStackTrace();
            }

            quoteRequest.setSingleTripDetails(details);

        }else{
            quoteRequest.setPolicyType(PolicyType.MULTI);
        }



        return quoteRequest;

    }
}
