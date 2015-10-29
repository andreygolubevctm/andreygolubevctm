package com.ctm.web.homecontents.providers.model;

import com.ctm.web.homecontents.model.results.*;
import com.ctm.web.homecontents.model.results.Price;
import com.ctm.web.homecontents.model.results.ProductDisclosure;
import com.ctm.web.homecontents.model.results.Underwriter;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.web.homecontents.providers.model.response.HomeQuote;
import com.ctm.web.homecontents.providers.model.response.HomeResponse;
import com.ctm.web.homecontents.providers.model.response.MoreInfo;
import com.ctm.web.travel.quote.model.QuoteResponse;
import com.ctm.web.homecontents.providers.model.request.HomeQuoteRequest;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ResponseAdapter {

    public static List<HomeResult> adapt(HomeQuoteRequest request, HomeResponse response) {
        
        List<HomeResult> results = new ArrayList<>();
        final QuoteResponse<HomeQuote> quoteResponse = response.getPayload();
        
        if (quoteResponse != null) {
            for (HomeQuote homeQuote : quoteResponse.getQuotes()) {
                HomeResult result = new HomeResult();
                result.setAvailable(homeQuote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setServiceName(homeQuote.getService());
                result.setProviderProductName(homeQuote.getProviderProductName());
                result.setProductId(homeQuote.getProductId());
                result.setTrackingProductId(getTrackingProductId(request, homeQuote));
                // check if BrandCode is REAL
                if ("REAL".equals(homeQuote.getBrandCode())) {
                    result.setBrandCode("REIN");
                } else {
                    result.setBrandCode(homeQuote.getBrandCode());
                }
                result.setQuoteNumber(homeQuote.getQuoteNumber());
                result.setQuoteUrl(homeQuote.getQuoteUrl());
                result.setProductName(homeQuote.getProductName());
                result.setProductDescription(homeQuote.getProductDescription());
                result.setDiscountOffer(homeQuote.getDiscountOffer());
                result.setDiscountOfferTerms(homeQuote.getDiscountOfferTerms());
                result.setAvailableOnline(homeQuote.isAvailableOnline());
                result.setHomeExcess(createExcess(homeQuote.getHomeExcess()));
                result.setDiscount(createDiscount(homeQuote.getDiscount()));
                result.setContentsExcess(createExcess(homeQuote.getContentsExcess()));
                result.setDisclaimer(homeQuote.getDisclaimer());
                result.setInclusions(homeQuote.getInclusions());
                result.setBenefits(homeQuote.getBenefits());
                result.setOptionalExtras(homeQuote.getOptionalExtras());
                result.setVdn(homeQuote.getVdn());

                if (homeQuote.getSpecialConditions() != null) {
                    result.setSpecialConditions(new ArrayList<>(homeQuote.getSpecialConditions()));
                }
                result.setContact(createContact(homeQuote.getContact()));
                result.setPrice(createPrice(homeQuote.getPrice()));
                result.setAdditionalExcesses(createAdditionalExcesses(homeQuote.getAdditionalExcesses()));
                result.setFeatures(createFeatures(homeQuote.getFeatures()));
                result.setUnderwriter(createUnderWriter(homeQuote.getUnderwriter()));
                result.setProductDisclosures(createProductDisclosures(homeQuote.getProductDisclosures()));
                results.add(result);
            }
        }
        return results;
    }

    private static Discount createDiscount(com.ctm.web.homecontents.providers.model.response.Discount quoteDiscount) {
        if (quoteDiscount != null) {
            Discount discount = new Discount();
            discount.setOffline(quoteDiscount.getOffline());
            discount.setOnline(quoteDiscount.getOnline());
            return discount;
        }
        return null;
    }

    private static String getTrackingProductId(HomeQuoteRequest request, HomeQuote homeQuote) {
        if (request.isHomeCover() && request.isContentsCover()) {
            return homeQuote.getProductId() + "-" + "HHZ";
        } else if (request.isHomeCover()) {
            return homeQuote.getProductId() + "-" + "HHB";
        } else {
            return homeQuote.getProductId() + "-" + "HHC";
        }
    }

    private static Excess createExcess(com.ctm.web.homecontents.providers.model.response.Excess quoteExcess) {
        if (quoteExcess != null) {
            Excess excess = new Excess();
            excess.setAmount(quoteExcess.getAmount());
            excess.setInsuredValue(quoteExcess.getInsuredValue());
            return excess;
        }
        return null;
    }

    private static List<ProductDisclosure> createProductDisclosures(List<com.ctm.web.homecontents.providers.model.response.ProductDisclosure> quoteProductDisclosures) {
        if (quoteProductDisclosures == null) return Collections.emptyList();
        List<ProductDisclosure> productDisclosures = new ArrayList<>();
        for (com.ctm.web.homecontents.providers.model.response.ProductDisclosure quoteProductDisclosure : quoteProductDisclosures) {
            ProductDisclosure productDisclosure = new ProductDisclosure();
            productDisclosure.setCode(quoteProductDisclosure.getCode());
            productDisclosure.setTitle(quoteProductDisclosure.getTitle());
            productDisclosure.setUrl(quoteProductDisclosure.getUrl());
            productDisclosures.add(productDisclosure);
        }
        return productDisclosures;
    }

    private static Underwriter createUnderWriter(com.ctm.web.homecontents.providers.model.response.Underwriter quoteUnderwriter) {
        if (quoteUnderwriter == null) return null;
        Underwriter underwriter = new Underwriter();
        underwriter.setName(quoteUnderwriter.getName());
        underwriter.setAbn(quoteUnderwriter.getAbn());
        underwriter.setAcn(quoteUnderwriter.getAcn());
        underwriter.setAfsLicenceNo(quoteUnderwriter.getAfsLicenceNo());
        return underwriter;
    }

    private static List<Feature> createFeatures(List<com.ctm.web.homecontents.providers.model.response.Feature> quoteFeatures) {
        if (quoteFeatures == null) return Collections.emptyList();
        List<Feature> features = new ArrayList<>();
        for (com.ctm.web.homecontents.providers.model.response.Feature quoteFeature : quoteFeatures) {
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
            List<com.ctm.web.homecontents.providers.model.response.AdditionalExcess> quoteAdditionalExcesses) {
        if (quoteAdditionalExcesses == null) return Collections.emptyList();
        List<AdditionalExcess> excesses = new ArrayList<>();
        for (com.ctm.web.homecontents.providers.model.response.AdditionalExcess quoteAdditionalExcess : quoteAdditionalExcesses) {
            AdditionalExcess excess = new AdditionalExcess();
            excess.setDescription(quoteAdditionalExcess.getDescription());
            excess.setAmount(quoteAdditionalExcess.getAmount());
            excesses.add(excess);
        }
        return excesses;
    }

    private static Price createPrice(com.ctm.web.homecontents.providers.model.response.Price quotePrice) {
        if (quotePrice == null) return null;
        Price price = new Price();
        price.setAnnualPremium(quotePrice.getAnnualPremium());
        price.setMonthlyPremium(quotePrice.getMonthlyPremium());
        price.setMonthlyFirstMonth(quotePrice.getMonthlyFirstMonth());
        price.setAnnualisedMonthlyPremium(quotePrice.getAnnualisedMonthlyPremium());
        return price;
    }

    private static Contact createContact(com.ctm.web.homecontents.providers.model.response.Contact quoteContact) {
        if (quoteContact == null) return null;
        Contact contact = new Contact();
        contact.setAllowCallMeBack(quoteContact.isAllowCallMeBack());
        contact.setAllowCallDirect(quoteContact.isAllowCallDirect());
        contact.setCallCentreHours(quoteContact.getCallCentreHours());
        contact.setPhoneNumber(quoteContact.getPhoneNumber());
        return contact;
    }

    public static HomeMoreInfo adapt(MoreInfo moreInfo) {
        HomeMoreInfo homeMoreInfo = new HomeMoreInfo();
        homeMoreInfo.setBenefits(moreInfo.getBenefits());
        homeMoreInfo.setInclusions(moreInfo.getInclusions());
        homeMoreInfo.setOptionalExtras(moreInfo.getOptionalExtras());
        return homeMoreInfo;
    }

}
