package com.ctm.web.travel.quote.model;

import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.form.TripType;
import com.ctm.web.travel.quote.model.request.*;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.IntStream;

import static com.ctm.web.core.utils.common.utils.LocalDateUtils.parseAUSLocalDate;

public class RequestAdapterV2 {

    /**
     * web_ctm to trave-quote adapter
     * Take request from the front-end and convert it to a java model to be sent to travel-quote.
     *
     * @param travelRequest
     * @return
     */
    public final static TravelQuoteRequest adapt(TravelRequest travelRequest) {

        // Retrieve quote as submitted from front end
        final TravelQuote quote = travelRequest.getQuote();

        // Convert front end quote request to travel-quote request
        TravelQuoteRequest quoteRequest = new TravelQuoteRequest();

        final List<Traveller> travellers = new ArrayList<>();

        quote.getTravellers().getTravellersAge()
                .stream()
                .map(age -> createTraveller(TravellerType.ADULT, Optional.of(age)))
                .forEach(travellers::add);

        IntStream.range(0, quote.getChildren())
                .mapToObj(i -> createTraveller(TravellerType.CHILD, Optional.empty()))
                .forEach(travellers::add);

        quoteRequest.setTravellers(travellers);

        if (quote.getPolicyType().equals("S")) {
            quoteRequest.setPolicyType(PolicyType.SINGLE);
            SingleTripDetails details = new SingleTripDetails();
            details.setDestinations(quote.getDestinations());

            details.setToDate(parseAUSLocalDate(quote.getDates().getToDate()));
            details.setFromDate(parseAUSLocalDate(quote.getDates().getFromDate()));

            quoteRequest.setSingleTripDetails(details);

        } else {
            quoteRequest.setPolicyType(PolicyType.MULTI);
        }

        if (quote.getRenderingMode() != null && quote.getRenderingMode().equalsIgnoreCase("XS")) {
            quoteRequest.setMobileUrls(true);
        }
        quoteRequest.setFirstName(quote.getFirstName());
        quoteRequest.setLastName(quote.getSurname());

        quoteRequest.setClientIp(travelRequest.getClientIpAddress());

        if(travelRequest.getTravel() != null && travelRequest.getTravel().getTripType() !=null){
            quoteRequest.setTripType(translateTripType(travelRequest.getTravel().getTripType()));
        }

        return quoteRequest;

    }

    private static com.ctm.web.travel.quote.model.request.TripType translateTripType(TripType formTripType){
        if(formTripType != null){
            com.ctm.web.travel.quote.model.request.TripType tripTypeRequest = new com.ctm.web.travel.quote.model.request.TripType();
            if(StringUtils.isNotBlank(formTripType.getAdventureSports())){
                tripTypeRequest.setAdventureSports(true);
            }

            if(StringUtils.isNotBlank(formTripType.getCruising())){
                tripTypeRequest.setCruising(true);
            }

            if(StringUtils.isNotBlank(formTripType.getSnowSports())){
                tripTypeRequest.setSnowSports(true);
            }
            return tripTypeRequest;
        }
        return null;
    }

    protected static Traveller createTraveller(TravellerType travellerType, Optional<Integer> age) {
        final Traveller traveller = new Traveller();
        traveller.setTravellerType(travellerType);
        age.ifPresent(traveller::setAge);
        return traveller;
    }
}
