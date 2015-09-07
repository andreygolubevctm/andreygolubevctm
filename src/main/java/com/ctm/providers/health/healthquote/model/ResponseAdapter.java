package com.ctm.providers.health.healthquote.model;

import com.ctm.model.content.Content;
import com.ctm.model.health.Frequency;
import com.ctm.model.health.PaymentType;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.health.results.*;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.providers.QuoteResponse;
import com.ctm.providers.health.healthquote.model.response.HealthQuote;
import com.ctm.providers.health.healthquote.model.response.HealthResponse;
import com.ctm.providers.health.healthquote.model.response.SpecialOffer;
import com.fasterxml.jackson.databind.JsonNode;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.ctm.model.health.Frequency.ANNUALLY;
import static com.ctm.model.health.Frequency.HALF_YEARLY;
import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;

public class ResponseAdapter {

    public static final String HEALTH_BROCHURE_URL = "health_brochure.jsp?pdf=";

    public static Pair<Boolean, List<HealthResult>> adapt(HealthRequest request, HealthResponse healthResponse, Content alternatePricingContent) {
        boolean hasPriceChanged = false;
        List<HealthResult> results = new ArrayList<>();
        QuoteResponse<HealthQuote> quoteResponse = healthResponse.getPayload();

        List<String> disabledFunds = emptyList();
        if (alternatePricingContent != null) {
            String supplementaryValueByKey = alternatePricingContent.getSupplementaryValueByKey("disabledFunds");
            if (StringUtils.isNotBlank(supplementaryValueByKey)) {
                disabledFunds = asList(StringUtils.split(supplementaryValueByKey, ","));
            }
        }

        if (quoteResponse != null) {
            int index = 1;
            for (HealthQuote quote : quoteResponse.getQuotes()) {
                HealthResult result = new HealthResult();

                result.setAvailable(quote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setTransactionId(request.getTransactionId());
                result.setServiceName("PHIO");
                result.setProductId(quote.getProductId());

                result.setPromo(createPromo(quote.getPromo()));
                result.setCustom(validateNode(quote.getCustom()));

                result.setPremium(createPremium(quote.getPremium(), quote.getInfo(), request.getQuote()));
                if (alternatePricingContent != null && StringUtils.equalsIgnoreCase(alternatePricingContent.getContentValue(), "Y")) {
                    com.ctm.providers.health.healthquote.model.response.Premium alternativePremium = quote.getAlternativePremium();
                    if (alternativePremium != null && !disabledFunds.contains(quote.getInfo().getFundCode())) {
                        result.setAltPremium(createPremium(alternativePremium, quote.getInfo(), request.getQuote()));
                    } else {
                        result.setAltPremium(createPremium(createDefaultPremium(), quote.getInfo(), request.getQuote()));
                    }
                } else {
                    result.setAltPremium(createPremium(quote.getPremium(), quote.getInfo(), request.getQuote()));
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

    private static com.ctm.providers.health.healthquote.model.response.Premium createDefaultPremium() {
        com.ctm.providers.health.healthquote.model.response.Premium premium =
                new com.ctm.providers.health.healthquote.model.response.Premium();
        com.ctm.providers.health.healthquote.model.response.Price defaultPrice = new com.ctm.providers.health.healthquote.model.response.Price();
        defaultPrice.setLhc(BigDecimal.ZERO);
        defaultPrice.setDiscountedPremium(BigDecimal.ZERO);
        defaultPrice.setGrossPremium(BigDecimal.ZERO);
        premium.setAnnually(defaultPrice);
        premium.setFortnightly(defaultPrice);
        premium.setMonthly(defaultPrice);
        premium.setWeekly(defaultPrice);
        premium.setHalfYearly(defaultPrice);
        premium.setQuarterly(defaultPrice);
        return premium;
    }

    private static JsonNode validateNode(JsonNode jsonNode) {
        if (!jsonNode.isNull()) {
            return jsonNode;
        }
        return null;
    }

    private static Promo createPromo(com.ctm.providers.health.healthquote.model.response.Promo quotePromo) {
        Promo promo = new Promo();
        promo.setPromoText(createPromoText(quotePromo.getSpecialOffer()));
        promo.setProviderPhoneNumber(quotePromo.getProviderPhoneNumber());
        promo.setDiscountText(StringUtils.trimToEmpty(quotePromo.getDiscountDescription()));
        promo.setExtrasPDF(HEALTH_BROCHURE_URL + quotePromo.getExtrasPDF());
        promo.setHospitalPDF(HEALTH_BROCHURE_URL + quotePromo.getHospitalPDF());
        return promo;
    }

    private static Premium createPremium(com.ctm.providers.health.healthquote.model.response.Premium quotePremium,
                                         com.ctm.providers.health.healthquote.model.response.Info info,
                                         com.ctm.model.health.form.HealthQuote healthQuote) {
        Premium premium = new Premium();
        premium.setAnnually(createPrice(quotePremium.getAnnually(), info, healthQuote));
        premium.setMonthly(createPrice(quotePremium.getMonthly(), info, healthQuote));
        premium.setFortnightly(createPrice(quotePremium.getFortnightly(), info, healthQuote));
        premium.setWeekly(createPrice(quotePremium.getWeekly(), info, healthQuote));
        premium.setHalfyearly(createPrice(quotePremium.getHalfYearly(), info, healthQuote));
        premium.setQuarterly(createPrice(quotePremium.getQuarterly(), info, healthQuote));
        return premium;
    }

    private static Price createPrice(com.ctm.providers.health.healthquote.model.response.Price quotePrice,
                                     com.ctm.providers.health.healthquote.model.response.Info info,
                                     com.ctm.model.health.form.HealthQuote healthQuote) {



        Price price = new Price();


        boolean hasDiscountRates = hasDiscountRates(Frequency.findByCode(healthQuote.getFilter().getFrequency()), info.getFundCode(), null,
                StringUtils.equalsIgnoreCase(healthQuote.getOnResultsPage(), "Y"));

        price.setDiscounted(hasDiscountRates ? "Y" : "N");
        String star = "";
        BigDecimal premium = quotePrice.getGrossPremium();
        if (hasDiscountRates) {
            premium = quotePrice.getDiscountedPremium();
            BigDecimal discount = quotePrice.getGrossPremium().subtract(quotePrice.getDiscountedPremium())
                .setScale(2, BigDecimal.ROUND_HALF_UP);
            BigDecimal discountPercentage = BigDecimal.ZERO;
            if (discount.doubleValue() > 0.0) {
                discountPercentage = discount.divide(quotePrice.getGrossPremium(), 2, BigDecimal.ROUND_HALF_UP)
                        .multiply(BigDecimal.valueOf(100));
            }
            star = "*";
            price.setDiscountAmount(formatCurrency(discount, true, true));
            price.setDiscountPercentage(discountPercentage);
        } else {
            price.setDiscountAmount(formatCurrency(BigDecimal.ZERO, true, true));
            price.setDiscountPercentage(BigDecimal.ZERO);
        }
        BigDecimal premiumWithRebateAndLHCDecimal = getPremiumWithRebateAndLHCDecimal(quotePrice.getLhc(), premium, healthQuote);
        price.setText(star + formatCurrency(premiumWithRebateAndLHCDecimal, true, true));
        price.setValue(premiumWithRebateAndLHCDecimal);

        BigDecimal loadingAmount = getLoadingAmountDecimal(quotePrice.getLhc(), healthQuote);
        BigDecimal rebateAmount = getRebateAmountDecimal(healthQuote, premium);
        BigDecimal lhcFreeValue = getLHCFreeValueDecimal(healthQuote, premium);

        price.setPricing("Includes rebate of " + formatCurrency(rebateAmount, true, true) + " & LHC loading of " + formatCurrency(loadingAmount, true, true));
        price.setLhcfreetext(star + formatCurrency(lhcFreeValue, true, true));
        price.setLhcfreevalue(lhcFreeValue);
        price.setLhcfreepricing("+ " + formatCurrency(loadingAmount, true, true) + " LHC inc " + formatCurrency(rebateAmount, true, true) + " Government Rebate");
        price.setHospitalValue(quotePrice.getLhc());
        price.setRebate(healthQuote.getRebate().intValue());
        price.setRebateValue(formatCurrency(rebateAmount, true, true));
        price.setLhcPercentage(healthQuote.getLoading());
        price.setLhc(formatCurrency(loadingAmount, true, true));
        price.setBase(formatCurrency(premium, true, true));
        price.setBaseAndLHC(formatCurrency(getBaseAndLHC(healthQuote, quotePrice.getLhc(), premium), true, true));
        price.setGrossPremium(formatCurrency(quotePrice.getGrossPremium(), true, true));
        return price;
    }

    /**
     DISCOUNT HACK: NEEDS TO BE REVISED
     if onResultsPage = true
     = Discount
     Show all .. and default to discount rates

     else if NIB + Bank account
     = Discount

     else if GMHBA + Bank account
     = Discount

     else if GMF + Annualy payment
     = Discount

     else if HIF + Annualy/Halfyealy payment
     = Discount

     else if BUD || AUF
     = Discount

     else
     = No Discount

     1=AUF, 3=NIB, 5=GMHBA, 6=GMF, 54=BUD, 11=HIF
     **/
    public static boolean hasDiscountRates(Frequency frequency, String provider, PaymentType paymentType, boolean onResultsPage) {
        boolean isBankAccount = paymentType != null && paymentType == PaymentType.BANK;
        boolean isDiscountRates ;
        switch(provider){
            case "NIB":
                isDiscountRates = onResultsPage || isBankAccount;
                break;
            case "GMH":
                isDiscountRates = onResultsPage || isBankAccount;
                break;
            case "GMF":
                isDiscountRates = onResultsPage || frequency.equals(ANNUALLY);
                break;
            case "HIF":
                isDiscountRates = onResultsPage || frequency.equals(ANNUALLY) || frequency.equals(HALF_YEARLY);
                break;
            case "BUD":
            case "AUF":
                isDiscountRates = true;
                break;
            default:
                isDiscountRates = false;
        }
        return isDiscountRates;
    }

    public static BigDecimal getPremiumWithRebateAndLHCDecimal(BigDecimal lhc, BigDecimal premium,
                                                               com.ctm.model.health.form.HealthQuote healthQuote) {
        BigDecimal calculatedLhc = getLoadingAmountDecimal(lhc, healthQuote);
        BigDecimal calculatedPremiumWithRebate =getLHCFreeValueDecimal(healthQuote, premium);
        return calculatedPremiumWithRebate.add(calculatedLhc).setScale(2, BigDecimal.ROUND_HALF_UP);
    }

    private static BigDecimal getLoadingAmountDecimal(BigDecimal lhc,
                                                      com.ctm.model.health.form.HealthQuote healthQuote) {
        BigDecimal loading = BigDecimal.valueOf(healthQuote.getLoading());
        String membership = healthQuote.getSituation().getHealthCvr();

        if(lhc.equals(new BigDecimal(0)) || loading.equals(new BigDecimal(0))) {
            return new BigDecimal(0);
        } else if(membership.equals("F") || membership.equals("C")) {
            BigDecimal halfPremium = lhc.divide(new BigDecimal(2));
            BigDecimal precentageLoading = loading.divide(new BigDecimal(100));
            // Round to the nearest cent using half up
            BigDecimal individualLoading = halfPremium.multiply(precentageLoading).setScale(2, BigDecimal.ROUND_HALF_UP);
            BigDecimal calculatedPremium = individualLoading.multiply(new BigDecimal(2));
            return calculatedPremium;
        } else {
            BigDecimal precentageLoading = loading.divide(new BigDecimal(100));
            // Round to the nearest cent using half up
            BigDecimal calculatedPremium = lhc.multiply(precentageLoading).setScale(2, BigDecimal.ROUND_HALF_UP);
            return calculatedPremium;
        }
    }

    private static BigDecimal getLHCFreeValueDecimal(com.ctm.model.health.form.HealthQuote healthQuote,
                                                     BigDecimal premium) {
        BigDecimal calculatedPremium;
        Double rebate = healthQuote.getRebate();
        if (rebate != 100.0) {
            //e.g. 0.7096 = (100 - 29.04) / 100
            BigDecimal rebateCalc = new BigDecimal(100).subtract(BigDecimal.valueOf(rebate)).divide(new BigDecimal(100));
            calculatedPremium = premium.multiply(rebateCalc).setScale(2, BigDecimal.ROUND_HALF_UP);
        } else {
            calculatedPremium = premium;
        }
        return calculatedPremium;
    }

    public static BigDecimal getRebateAmountDecimal(com.ctm.model.health.form.HealthQuote healthQuote,
                                                    BigDecimal premium) {
        BigDecimal rebate = BigDecimal.valueOf(healthQuote.getRebate());
        BigDecimal rebateAmount;
        if(rebate.doubleValue() != 100.0) {
            BigDecimal rebateCalcReal = rebate.divide(new BigDecimal(100));
            rebateAmount =  premium.multiply(rebateCalcReal).setScale(2, BigDecimal.ROUND_HALF_UP);
        }else{
            rebateAmount = new BigDecimal(0.0);
        }
        return rebateAmount;
    }

    public static BigDecimal getBaseAndLHC(com.ctm.model.health.form.HealthQuote healthQuote,
                                           BigDecimal lhc,
                                           BigDecimal premium) {
        BigDecimal loadingAmount= getLoadingAmountDecimal(lhc, healthQuote);
        return loadingAmount.add(premium);
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
                        .append(specialOffer.getTerms())
                        .append("\" title=\"Conditions\">")
                        .append("^ Conditions")
                        .append("</a>")
                        .append("</p>");
            }
        }
        return sb.toString();
    }

    private static Info createInfo(com.ctm.providers.health.healthquote.model.response.Info responseInfo, int index) {
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
        // Rank is normally the benefit count so is the same across all results.
        // FIXME: Until we have proper benefits scoring, make rank the numeric order of the results as they were returned in the SQL: 1 to 12
        info.setRank(index);
        info.setOtherProductFeatures(responseInfo.getOtherProductFeatures());
        Map<String, String> otherInfoProperties = responseInfo.getOtherInfoProperties();
        info.setCategory(otherInfoProperties.get("Category"));
        info.setFundCode(otherInfoProperties.get("FundCode"));
        info.setProductType(otherInfoProperties.get("ProductType"));
        info.setState(otherInfoProperties.get("State"));
        return info;
    }
}
