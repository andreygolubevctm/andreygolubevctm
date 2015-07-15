package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.AvailableType;
import com.ctm.model.travel.TravelResult;
import com.ctm.providers.QuoteResponse;
import com.ctm.providers.travel.travelquote.model.response.TravelQuote;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by twilson on 14/07/2015.
 */
public class ResponseAdapter {

    public static List<TravelResult> adapt(TravelResponse response) {
        List<TravelResult> results = new ArrayList<>();
        final QuoteResponse<TravelQuote> quoteResponse = response.getPayload();
        if (quoteResponse != null) {
            for (TravelQuote carQuote : quoteResponse.getQuotes()) {
                TravelResult result = new TravelResult();
                result.setAvailable(carQuote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setServiceName(carQuote.getService());
                result.setProviderProductName(carQuote.getProviderProductName());
                result.setProductId(carQuote.getProductId());
                result.setBrandCode(carQuote.getBrandCode());
                result.setQuoteNumber(carQuote.getQuoteNumber());
                result.setQuoteUrl(carQuote.getQuoteUrl());
                result.setProductName(carQuote.getProductName());
                result.setProductDescription(carQuote.getProductDescription());
                result.setDiscountOffer(carQuote.getDiscountOffer());
                result.setDiscountOfferTerms(carQuote.getDiscountOfferTerms());
                result.setAvailableOnline(carQuote.isAvailableOnline());
                result.setExcess(carQuote.getExcess());
                result.setDisclaimer(carQuote.getDisclaimer());
                result.setInclusions(carQuote.getInclusions());
                result.setBenefits(carQuote.getBenefits());
                result.setOptionalExtras(carQuote.getOptionalExtras());
                result.setVdn(carQuote.getVdn());

                if (carQuote.getSpecialConditions() != null) {
                    result.setSpecialConditions(new ArrayList<>(carQuote.getSpecialConditions()));
                }
                result.setContact(createContact(carQuote.getContact()));
                result.setPrice(createPrice(carQuote.getPrice()));
                result.setDiscount(createDiscount(carQuote.getDiscount()));
                result.setAdditionalExcesses(createAdditionalExcesses(carQuote.getAdditionalExcesses()));
                result.setFeatures(createFeatures(carQuote.getFeatures()));
                result.setUnderwriter(createUnderWriter(carQuote.getUnderwriter()));
                result.setProductDisclosures(createProductDisclosures(carQuote.getProductDisclosures()));
                results.add(result);

            }

        }
        return results;
    }
}
