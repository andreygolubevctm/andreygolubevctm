package com.ctm.web.health.quote.model;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.providers.model.QuoteResponse;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.*;
import com.ctm.web.health.quote.model.response.HealthQuote;
import com.ctm.web.health.quote.model.response.HealthResponse;
import com.ctm.web.health.quote.model.response.Promotion;
import com.ctm.web.health.quote.model.response.SpecialOffer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.TextNode;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.ctm.web.health.quote.model.response.Price.DEFAULT_PRICE;
import static java.util.Collections.emptyList;

public class ResponseAdapter {

    public static final String HEALTH_BROCHURE_URL = "health_brochure.jsp?pdf=";

    public static Pair<Boolean, List<HealthQuoteResult>> adapt(HealthRequest request, HealthResponse healthResponse, Content alternatePricingContent) {
        boolean hasPriceChanged = false;
        List<HealthQuoteResult> results = new ArrayList<>();
        QuoteResponse<HealthQuote> quoteResponse = healthResponse.getPayload();

        // Check if the response is unavailable
        if (quoteResponse.getQuotes()
                .stream()
                .allMatch(q -> !q.isAvailable())) {

            return Pair.of(true, emptyList());

        } else {

            if (quoteResponse != null) {
                int index = 1;
                for (HealthQuote quote : quoteResponse.getQuotes()) {
                    HealthQuoteResult result = new HealthQuoteResult();

                    result.setAvailable(quote.isAvailable() ? AvailableType.Y : AvailableType.N);
                    result.setTransactionId(request.getTransactionId());
                    result.setServiceName("PHIO");
                    result.setProductId(quote.getProductId());

                    result.setPromo(createPromo(quote.getPromotion(),request.getStaticOverride()));
                    result.setCustom(validateNode(quote.getCustom()));

                    if (quote.getPremium() != null) {
                        result.setPremium(createPremium(quote.getPremium(), quote.getInfo(), request.getQuote()));
                        if (alternatePricingContent != null && StringUtils.equalsIgnoreCase(alternatePricingContent.getContentValue(), "Y")) {
                            com.ctm.web.health.quote.model.response.Premium alternativePremium = quote.getAlternativePremium();
                            if (alternativePremium != null) {
                                result.setAltPremium(createPremium(alternativePremium, quote.getInfo(), request.getQuote()));
                            } else {
                                result.setAltPremium(createPremium(createDefaultPremium(), quote.getInfo(), request.getQuote()));
                            }
                        } else {
                            result.setAltPremium(createPremium(quote.getPremium(), quote.getInfo(), request.getQuote()));
                        }
                    } else if (quote.getPaymentTypePremiums() != null) {
                        final HashMap<String, Premium> paymentTypePremiums = new HashMap<>();
                        quote.getPaymentTypePremiums().entrySet()
                                .stream()
                                .forEach(entry -> {
                                    paymentTypePremiums.put(getPaymentType(entry.getKey()), createPremium(entry.getValue(), quote.getInfo(), request.getQuote()));
                                });
                        result.setPaymentTypePremiums(paymentTypePremiums);
                        if (quote.getPaymentTypeAltPremiums() != null && !quote.getPaymentTypeAltPremiums().isEmpty()) {
                            final HashMap<String, Premium> paymentTypeAltPremiums = new HashMap<>();
                            quote.getPaymentTypeAltPremiums().entrySet()
                                    .stream()
                                    .forEach(entry -> {
                                        paymentTypeAltPremiums.put(getPaymentType(entry.getKey()), createPremium(entry.getValue(), quote.getInfo(), request.getQuote()));
                                    });
                            result.setPaymentTypeAltPremiums(paymentTypeAltPremiums);
                        }
                    }


                    result.setInfo(createInfo(quote.getInfo(), index++));
                    result.setHospital(validateNode(quote.getHospital()));
                    result.setExtras(validateNode(quote.getExtras()));
                    result.setAmbulance(validateNode(quote.getAmbulance()));

                    if (quote.isPriceChanged()) {
                        hasPriceChanged = true;
                    }
                    results.add(result);
                }

            }


            return Pair.of(hasPriceChanged, results);
        }
    }

    private static String getPaymentType(PaymentType paymentType) {
        switch (paymentType) {
            case BANK: return "BankAccount";
            case CREDIT: return "CreditCard";
            case INVOICE: return "Invoice";
            default:
                throw new RuntimeException("Not supported paymentType " +  paymentType);
        }
    }

    private static com.ctm.web.health.quote.model.response.Premium createDefaultPremium() {
        com.ctm.web.health.quote.model.response.Premium premium =
                new com.ctm.web.health.quote.model.response.Premium();
        premium.setAnnually(DEFAULT_PRICE);
        premium.setFortnightly(DEFAULT_PRICE);
        premium.setMonthly(DEFAULT_PRICE);
        premium.setWeekly(DEFAULT_PRICE);
        premium.setHalfYearly(DEFAULT_PRICE);
        premium.setQuarterly(DEFAULT_PRICE);
        return premium;
    }

    private static JsonNode validateNode(JsonNode jsonNode) {
        if (!jsonNode.isNull()) {
            return jsonNode;
        }
        return new TextNode("");
    }

    private static Promo createPromo(Promotion quotePromotion, String staticBranch) {
        Promo promo = new Promo();
        promo.setPromoText(createPromoText(quotePromotion.getSpecialOffer()));
        promo.setProviderPhoneNumber(quotePromotion.getProviderPhoneNumber());
        promo.setDiscountText(StringUtils.trimToEmpty(quotePromotion.getDiscountDescription()));
        promo.setExtrasPDF(HEALTH_BROCHURE_URL + quotePromotion.getExtrasPDF() + (staticBranch != null ? ("&staticBranch=" + staticBranch) : ""));
        promo.setHospitalPDF(HEALTH_BROCHURE_URL + quotePromotion.getHospitalPDF() + (staticBranch != null ? ("&staticBranch=" + staticBranch) : ""));
        return promo;
    }

    private static Premium createPremium(com.ctm.web.health.quote.model.response.Premium quotePremium,
                                         com.ctm.web.health.quote.model.response.Info info,
                                         com.ctm.web.health.model.form.HealthQuote healthQuote) {
        Premium premium = new Premium();
        premium.setAnnually(createPrice(quotePremium.getAnnually(), healthQuote));
        premium.setMonthly(createPrice(quotePremium.getMonthly(), healthQuote));
        premium.setFortnightly(createPrice(quotePremium.getFortnightly(), healthQuote));
        premium.setWeekly(createPrice(quotePremium.getWeekly(), healthQuote));
        premium.setHalfyearly(createPrice(quotePremium.getHalfYearly(), healthQuote));
        premium.setQuarterly(createPrice(quotePremium.getQuarterly(), healthQuote));
        return premium;
    }

    private static Price createPrice(com.ctm.web.health.quote.model.response.Price quotePrice,
                                     com.ctm.web.health.model.form.HealthQuote healthQuote) {

        if (quotePrice == null) return null;

        Price price = new Price();

        final boolean hasDiscount = quotePrice.getDiscountPercentage().compareTo(BigDecimal.ZERO) > 0;
        price.setDiscounted(hasDiscount ? "Y" : "N");
        price.setDiscountAmount(formatCurrency(quotePrice.getDiscountAmount(), true, true));
        price.setDiscountPercentage(quotePrice.getDiscountPercentage());
        price.setText(formatCurrency(quotePrice.getPayableAmount(), true, true) + (hasDiscount ? "*" : ""));
        price.setValue(quotePrice.getPayableAmount());
        price.setPricing("Includes rebate of " + formatCurrency(quotePrice.getRebateAmount(), true, true) + " & LHC loading of " +
                formatCurrency(quotePrice.getLhcAmount(), true, true));
        price.setLhcfreetext(formatCurrency(quotePrice.getLhcFreeAmount(), true, true) + (hasDiscount ? "*" : ""));
        price.setLhcfreevalue(quotePrice.getLhcFreeAmount());
        price.setLhcfreepricing("+ " + formatCurrency(quotePrice.getLhcAmount(), true, true) + " LHC inc " +
                formatCurrency(quotePrice.getRebateAmount(), true, true) + " Government Rebate");
        price.setRebateValue(formatCurrency(quotePrice.getRebateAmount(), true, true));
        price.setBase(formatCurrency(quotePrice.getBasePremium(), true, true));
        price.setBaseAndLHC(formatCurrency(quotePrice.getBaseAndLHC(), true, true));

        price.setHospitalValue(quotePrice.getHospitalValue());
        price.setRebate(quotePrice.getRebatePercentage());
        price.setLhcPercentage(healthQuote.getLoading());
        price.setLhc(formatCurrency(quotePrice.getLhcAmount(), true, true));
        price.setGrossPremium(formatCurrency(quotePrice.getGrossPremium(), true, true));
        return price;
    }


    public static String formatCurrency(BigDecimal value, boolean showSymbol, boolean groupingUsed) {
        NumberFormat form;
        if(showSymbol) {
            form = NumberFormat.getCurrencyInstance();
        } else {
            form = NumberFormat.getInstance();
            form.setMinimumFractionDigits(2);
            form.setMaximumFractionDigits(2);
        }
        form.setRoundingMode(RoundingMode.HALF_UP);
        form.setGroupingUsed(groupingUsed);

        return form.format(value);
    }

    private static String createPromoText(SpecialOffer specialOffer) {
        StringBuilder sb = new StringBuilder("");
        if (specialOffer != null) {
            sb.append(StringUtils.trimToEmpty(specialOffer.getSummary()));
            if (StringUtils.isNotBlank(specialOffer.getTerms())) {
                sb.append("<p>").append("<a class=\"dialogPop\" data-content=\"")
                        .append(StringEscapeUtils.escapeHtml4(specialOffer.getTerms()))
                        .append("\" title=\"Conditions\">")
                        .append("^ Conditions")
                        .append("</a>")
                        .append("</p>");
            }
        }
        return sb.toString();
    }

    private static Info createInfo(com.ctm.web.health.quote.model.response.Info responseInfo, int index) {
        Info info = new Info();
        info.setRestrictedFund(responseInfo.isRestrictedFund() ? "Y" : "N");
        info.setProvider(responseInfo.getFundCode());
        info.setProviderName(responseInfo.getFundName());
        info.setProviderId(responseInfo.getProviderId());
        info.setProductCode(responseInfo.getProductCode());
        info.setProductTitle(responseInfo.getTitle());
        info.setTrackCode("UNKNOWN");
        info.setName(responseInfo.getName());
        info.setDes(responseInfo.getDescription());
        info.setRank(responseInfo.getRank());
        info.setOtherProductFeatures(responseInfo.getOtherProductFeatures());
        Map<String, String> otherInfoProperties = responseInfo.getOtherInfoProperties();
        info.setCategory(otherInfoProperties.get("Category"));
        info.setFundCode(otherInfoProperties.get("FundCode"));
        info.setProductType(otherInfoProperties.get("ProductType"));
        info.setState(otherInfoProperties.get("State"));
        return info;
    }
}
