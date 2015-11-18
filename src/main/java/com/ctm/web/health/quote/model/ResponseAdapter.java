package com.ctm.web.health.quote.model;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.providers.model.QuoteResponse;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.health.model.Frequency;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Payment;
import com.ctm.web.health.model.form.PaymentDetails;
import com.ctm.web.health.model.results.*;
import com.ctm.web.health.model.results.Info;
import com.ctm.web.health.model.results.Premium;
import com.ctm.web.health.model.results.Price;
import com.ctm.web.health.quote.model.response.*;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.TextNode;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.ctm.web.health.model.Frequency.*;
import static java.util.Arrays.asList;
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
                    HealthQuoteResult result = new HealthQuoteResult();

                    result.setAvailable(quote.isAvailable() ? AvailableType.Y : AvailableType.N);
                    result.setTransactionId(request.getTransactionId());
                    result.setServiceName("PHIO");
                    result.setProductId(quote.getProductId());

                    result.setPromo(createPromo(quote.getPromotion()));
                    result.setCustom(validateNode(quote.getCustom()));

                    result.setPremium(createPremium(quote.getPremium(), quote.getInfo(), request.getQuote()));
                    if (alternatePricingContent != null && StringUtils.equalsIgnoreCase(alternatePricingContent.getContentValue(), "Y")) {
                        com.ctm.web.health.quote.model.response.Premium alternativePremium = quote.getAlternativePremium();
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
    }

    private static com.ctm.web.health.quote.model.response.Premium createDefaultPremium() {
        com.ctm.web.health.quote.model.response.Premium premium =
                new com.ctm.web.health.quote.model.response.Premium();
        com.ctm.web.health.quote.model.response.Price defaultPrice = new com.ctm.web.health.quote.model.response.Price();
        defaultPrice.setLhc(BigDecimal.ZERO);
        defaultPrice.setLoadingAmount(BigDecimal.ZERO);
        defaultPrice.setGrossPremium(BigDecimal.ZERO);
        defaultPrice.setDiscountedPrice(null);
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
        return new TextNode("");
    }

    private static Promo createPromo(Promotion quotePromotion) {
        Promo promo = new Promo();
        promo.setPromoText(createPromoText(quotePromotion.getSpecialOffer()));
        promo.setProviderPhoneNumber(quotePromotion.getProviderPhoneNumber());
        promo.setDiscountText(StringUtils.trimToEmpty(quotePromotion.getDiscountDescription()));
        promo.setExtrasPDF(HEALTH_BROCHURE_URL + quotePromotion.getExtrasPDF());
        promo.setHospitalPDF(HEALTH_BROCHURE_URL + quotePromotion.getHospitalPDF());
        return promo;
    }

    private static Premium createPremium(com.ctm.web.health.quote.model.response.Premium quotePremium,
                                         com.ctm.web.health.quote.model.response.Info info,
                                         com.ctm.web.health.model.form.HealthQuote healthQuote) {
        Premium premium = new Premium();
        premium.setAnnually(createPrice(quotePremium.getAnnually(), info, healthQuote, ANNUALLY));
        premium.setMonthly(createPrice(quotePremium.getMonthly(), info, healthQuote, MONTHLY));
        premium.setFortnightly(createPrice(quotePremium.getFortnightly(), info, healthQuote, FORTNIGHTLY));
        premium.setWeekly(createPrice(quotePremium.getWeekly(), info, healthQuote, WEEKLY));
        premium.setHalfyearly(createPrice(quotePremium.getHalfYearly(), info, healthQuote, HALF_YEARLY));
        premium.setQuarterly(createPrice(quotePremium.getQuarterly(), info, healthQuote, QUARTERLY));
        return premium;
    }

    private static Price createPrice(com.ctm.web.health.quote.model.response.Price quotePrice,
                                     com.ctm.web.health.quote.model.response.Info info,
                                     com.ctm.web.health.model.form.HealthQuote healthQuote, Frequency frequency) {



        Price price = new Price();


        final Optional<PaymentType> type = Optional.ofNullable(healthQuote)
                                .map(com.ctm.web.health.model.form.HealthQuote::getPayment)
                                .map(Payment::getDetails)
                                .map(PaymentDetails::getType)
                                .map(PaymentType::findByCode);
        boolean hasDiscountRates = hasDiscountRates(frequency, info.getFundCode(), type,
                StringUtils.equalsIgnoreCase(healthQuote.getOnResultsPage(), "Y"));

        price.setDiscounted(hasDiscountRates ? "Y" : "N");
        final BigDecimal loadingAmount = quotePrice.getLoadingAmount();
        if (hasDiscountRates && quotePrice.getDiscountedPrice() != null) {
            final DiscountedPrice discountedPrice = quotePrice.getDiscountedPrice();
            price.setDiscountAmount(formatCurrency(discountedPrice.getDiscountAmount(), true, true));
            price.setDiscountPercentage(discountedPrice.getDiscountPercentage());
            final BigDecimal lhcFreeAmount = discountedPrice.getLhcFreeAmount();
            BigDecimal premiumWithRebateAndLHCDecimal = loadingAmount
                    .add(lhcFreeAmount).setScale(2, BigDecimal.ROUND_HALF_UP);
            price.setText("*" + formatCurrency(premiumWithRebateAndLHCDecimal, true, true));
            price.setValue(premiumWithRebateAndLHCDecimal);

            final BigDecimal rebateAmount = discountedPrice.getRebateAmount();
            price.setPricing("Includes rebate of " + formatCurrency(rebateAmount, true, true) + " & LHC loading of " +
                    formatCurrency(loadingAmount, true, true));
            price.setLhcfreetext("*" + formatCurrency(lhcFreeAmount, true, true));
            price.setLhcfreevalue(lhcFreeAmount);
            price.setLhcfreepricing("+ " + formatCurrency(loadingAmount, true, true) + " LHC inc " +
                    formatCurrency(rebateAmount, true, true) + " Government Rebate");
            price.setRebateValue(formatCurrency(rebateAmount, true, true));
            price.setBase(formatCurrency(discountedPrice.getDiscountedPremium(), true, true));
            price.setBaseAndLHC(formatCurrency(loadingAmount.add(discountedPrice.getDiscountedPremium()), true, true));


        } else {
            price.setDiscountAmount(formatCurrency(BigDecimal.ZERO, true, true));
            price.setDiscountPercentage(BigDecimal.ZERO);

            BigDecimal premiumWithRebateAndLHCDecimal = loadingAmount
                    .add(quotePrice.getLhcFreeAmount()).setScale(2, BigDecimal.ROUND_HALF_UP);
            price.setText(formatCurrency(premiumWithRebateAndLHCDecimal, true, true));
            price.setValue(premiumWithRebateAndLHCDecimal);

            price.setPricing("Includes rebate of " + formatCurrency(quotePrice.getRebateAmount(), true, true) + " & LHC loading of " +
                    formatCurrency(loadingAmount, true, true));
            price.setLhcfreetext(formatCurrency(quotePrice.getLhcFreeAmount(), true, true));
            price.setLhcfreevalue(quotePrice.getLhcFreeAmount());
            price.setLhcfreepricing("+ " + formatCurrency(loadingAmount, true, true) + " LHC inc " +
                    formatCurrency(quotePrice.getRebateAmount(), true, true) + " Government Rebate");
            price.setRebateValue(formatCurrency(quotePrice.getRebateAmount(), true, true));
            price.setBase(formatCurrency(quotePrice.getGrossPremium(), true, true));
            price.setBaseAndLHC(formatCurrency(loadingAmount.add(quotePrice.getGrossPremium()), true, true));
        }


        price.setHospitalValue(quotePrice.getLhc());
        price.setRebate(healthQuote.getRebate().intValue());
        price.setLhcPercentage(healthQuote.getLoading());
        price.setLhc(formatCurrency(loadingAmount, true, true));
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
    public static boolean hasDiscountRates(Frequency frequency, String provider, Optional<PaymentType> paymentType, boolean onResultsPage) {
        boolean isBankAccount = paymentType
                .filter(v -> v == PaymentType.BANK)
                .isPresent();
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
