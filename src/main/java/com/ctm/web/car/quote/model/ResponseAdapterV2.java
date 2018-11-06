package com.ctm.web.car.quote.model;

import com.ctm.web.car.model.results.*;
import com.ctm.web.car.quote.model.response.CarQuote;
import com.ctm.web.car.quote.model.response.CarResponseV2;
import com.ctm.web.core.providers.model.IncomingQuotesResponse;
import com.ctm.web.core.resultsData.model.AvailableType;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ResponseAdapterV2 {

    public static List<CarResult> adapt(CarResponseV2 response) {
        List<CarResult> results = new ArrayList<>();
        final IncomingQuotesResponse.Payload<CarQuote> quoteResponse = response.getPayload();
        if (quoteResponse != null) {
            for (CarQuote carQuote : quoteResponse.getQuotes()) {
                CarResult result = new CarResult();
                result.setAvailable(carQuote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setServiceName(carQuote.getService());
                result.setProviderProductName(carQuote.getProviderProductName());
                result.setProductId(carQuote.getProductId());
                // check if BrandCode is REAL
                if ("REAL".equals(carQuote.getBrandCode())) {
                    result.setBrandCode("REIN");
                } else {
                    result.setBrandCode(carQuote.getBrandCode());
                }
                result.setQuoteNumber(carQuote.getQuoteNumber());
                result.setQuoteUrl(carQuote.getQuoteUrl());
                result.setProductName(carQuote.getProductName());
                result.setProductDescription(carQuote.getProductDescription());
                result.setDiscountOffer(carQuote.getDiscountOffer());
                result.setDiscountOfferTerms(carQuote.getDiscountOfferTerms());
                result.setAvailableOnline(carQuote.isAvailableOnline());
                result.setExcesses(new Excess(carQuote.getExcess(), carQuote.getGlassExcess()));
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
                result.setAdditionalExcesses(createAdditionalExcesses(carQuote.getAdditionalExcesses()));
                result.setFeatures(createFeatures(carQuote.getFeatures()));
                result.setUnderwriter(createUnderWriter(carQuote.getUnderwriter()));
                result.setProductDisclosures(createProductDisclosures(carQuote.getProductDisclosures()));
                result.setFollowupIntended(carQuote.getFollowupIntended());
                results.add(result);

            }

        }
        return results;
    }

    private static List<ProductDisclosure> createProductDisclosures(List<com.ctm.web.car.quote.model.response.ProductDisclosure> quoteProductDisclosures) {
        if (quoteProductDisclosures == null) return Collections.emptyList();
        List<ProductDisclosure> productDisclosures = new ArrayList<>();
        for (com.ctm.web.car.quote.model.response.ProductDisclosure quoteProductDisclosure : quoteProductDisclosures) {
            ProductDisclosure productDisclosure = new ProductDisclosure();
            productDisclosure.setCode(quoteProductDisclosure.getCode());
            productDisclosure.setTitle(quoteProductDisclosure.getTitle());
            productDisclosure.setUrl(quoteProductDisclosure.getUrl());
            productDisclosures.add(productDisclosure);
        }
        return productDisclosures;
    }

    private static Underwriter createUnderWriter(com.ctm.web.car.quote.model.response.Underwriter quoteUnderwriter) {
        if (quoteUnderwriter == null) return null;
        Underwriter underwriter = new Underwriter();
        underwriter.setName(quoteUnderwriter.getName());
        underwriter.setAbn(quoteUnderwriter.getABN());
        underwriter.setAcn(quoteUnderwriter.getACN());
        underwriter.setAfsLicenceNo(quoteUnderwriter.getAFSLicenceNo());
        return underwriter;
    }

    private static List<Feature> createFeatures(List<com.ctm.web.car.quote.model.response.Feature> quoteFeatures) {
        if (quoteFeatures == null) return Collections.emptyList();
        List<Feature> features = new ArrayList<>();
        for (com.ctm.web.car.quote.model.response.Feature quoteFeature : quoteFeatures) {
            Feature feature = new Feature();
            feature.setCode(quoteFeature.getCode());
            feature.setLabel(quoteFeature.getLabel());
            feature.setValue(quoteFeature.getValue());
            feature.setExtra(quoteFeature.getExtra());
            features.add(feature);
        }
        return features;
    }

    private static List<AdditionalExcess> createAdditionalExcesses(
            List<com.ctm.web.car.quote.model.response.AdditionalExcess> quoteAdditionalExcesses) {
        if (quoteAdditionalExcesses == null) return Collections.emptyList();
        List<AdditionalExcess> excesses = new ArrayList<>();
        for (com.ctm.web.car.quote.model.response.AdditionalExcess quoteAdditionalExcess : quoteAdditionalExcesses) {
            AdditionalExcess excess = new AdditionalExcess();
            excess.setDescription(quoteAdditionalExcess.getDescription());
            excess.setAmount(quoteAdditionalExcess.getAmount());
            excesses.add(excess);
        }
        return excesses;
    }

    private static Price createPrice(com.ctm.web.car.quote.model.response.Price quotePrice) {
        if (quotePrice == null) return null;
        Price price = new Price();
        price.setAnnualPremium(quotePrice.getAnnualPremium());
        price.setMonthlyPremium(quotePrice.getMonthlyPremium());
        price.setMonthlyFirstMonth(quotePrice.getMonthlyFirstMonth());
        price.setAnnualisedMonthlyPremium(quotePrice.getAnnualisedMonthlyPremium());
        return price;
    }

    private static Contact createContact(com.ctm.web.car.quote.model.response.Contact quoteContact) {
        if (quoteContact == null) return null;
        Contact contact = new Contact();
        contact.setAllowCallMeBack(quoteContact.isAllowCallMeBack());
        contact.setAllowCallDirect(quoteContact.isAllowCallDirect());
        contact.setCallCentreHours(quoteContact.getCallCentreHours());
        contact.setPhoneNumber(quoteContact.getPhoneNumber());
        return contact;
    }

}
