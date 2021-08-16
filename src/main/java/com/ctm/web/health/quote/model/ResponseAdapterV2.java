package com.ctm.web.health.quote.model;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.providers.model.IncomingQuotesResponse;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.health.lhc.calculation.LHCDateCalculationSupport;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.form.HealthCover;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Insured;
import com.ctm.web.health.model.results.AwardScheme;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.model.results.Info;
import com.ctm.web.health.model.results.Premium;
import com.ctm.web.health.model.results.Price;
import com.ctm.web.health.model.results.Promo;
import com.ctm.web.health.quote.model.response.GiftCard;
import com.ctm.web.health.quote.model.response.HealthQuote;
import com.ctm.web.health.quote.model.response.HealthResponseV2;
import com.ctm.web.health.quote.model.response.Promotion;
import com.ctm.web.health.quote.model.response.SpecialOffer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.node.TextNode;
import com.google.common.annotations.VisibleForTesting;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.ctm.web.health.quote.model.response.Price.DEFAULT_PRICE;
import static java.util.Collections.emptyList;
import static java.util.Optional.empty;
import static java.util.Optional.ofNullable;

public class ResponseAdapterV2 {

    public static final String HEALTH_BROCHURE_URL = "health_brochure.jsp?pdf=%1$s%2$s%3$s";
    /**
     * ATLAS_QUOTE_BROCHURE_IDENTIFIER
     * This is used for new health quote brochure links, old health quote uses health_brochure.jsp while
     * new health quote sends an S3 bucket link directly to the UI
     */
    private static final String ATLAS_QUOTE_BROCHURE_IDENTIFIER = "http";

    public static ResponseAdapterModel adapt(final HealthRequest request, final HealthResponseV2 healthResponse, final Content alternatePricingContent, final String brandCode) {
        boolean hasPriceChanged = false;
        final List<HealthQuoteResult> results = new ArrayList<>();
        final IncomingQuotesResponse.Payload<HealthQuote> quoteResponse = healthResponse.getPayload();

        // Check if the response is unavailable
        if (quoteResponse.getQuotes()
                .stream()
                .allMatch(q -> !q.isAvailable())) {

            return new ResponseAdapterModel(true, emptyList());

        } else {

            if (quoteResponse != null) {
                int index = 1;
                final boolean isAlternatePricingContent = alternatePricingContent != null && StringUtils.equalsIgnoreCase(alternatePricingContent.getContentValue(), "Y");

                final Optional<BigDecimal> rebateChangeover = Optional.empty();

                final boolean isSimplesUser = Optional.ofNullable(request)
                        .map(HealthRequest::getHealth)
                        .map(com.ctm.web.health.model.form.HealthQuote::getSimples)
                        .isPresent();

                for (final HealthQuote quote : quoteResponse.getQuotes()) {
                    final HealthQuoteResult result = new HealthQuoteResult();

                    result.setAvailable(quote.isAvailable() ? AvailableType.Y : AvailableType.N);
                    result.setTransactionId(request.getTransactionId());
                    result.setServiceName("PHIO");
                    result.setProductId(quote.getProductId());
                    result.setProductUpi(quote.getProductUpi());

                    result.setPromo(createPromo(quote.getPromotion(), request.getStaticOverride(), isSimplesUser, brandCode));
                    result.setAwardScheme(createAwardScheme(quote.getPromotion(), isSimplesUser));
                    result.setCustom(validateNode(quote.getCustom()));

                    result.setDropDeadDate(quote.getDropDeadDate());
                    result.setPricingDate(quote.getPricingDate());

                    if (quote.getPremium() != null) {
                        result.setPremium(createPremium(quote.getPremium(), quote.getInfo(), request.getQuote(), policyTypeExists(quote.getHospital()), isSimplesUser));
                        if (isAlternatePricingContent) {
                            final com.ctm.web.health.quote.model.response.Premium alternativePremium = quote.getAlternativePremium();
                            if (alternativePremium != null) {
                                result.setAltPremium(createPremium(alternativePremium, quote.getInfo(), request.getQuote(), policyTypeExists(quote.getHospital()), rebateChangeover, isSimplesUser));
                            } else {
                                result.setAltPremium(createPremium(createDefaultPremium(), quote.getInfo(), request.getQuote(), policyTypeExists(quote.getHospital()), rebateChangeover, isSimplesUser));
                            }
                        } else {
                            result.setAltPremium(createPremium(quote.getPremium(), quote.getInfo(), request.getQuote(), policyTypeExists(quote.getHospital()), rebateChangeover, isSimplesUser));
                        }
                    } else if (quote.getPaymentTypePremiums() != null) {
                        final HashMap<String, Premium> paymentTypePremiums = new HashMap<>();
                        quote.getPaymentTypePremiums().entrySet()
                                .stream()
                                .forEach(entry -> {
                                    paymentTypePremiums.put(getPaymentType(entry.getKey()), createPremium(entry.getValue(), quote.getInfo(), request.getQuote(), policyTypeExists(quote.getHospital()), isSimplesUser));
                                });
                        result.setPaymentTypePremiums(paymentTypePremiums);
                        if (isAlternatePricingContent) {
                            final HashMap<String, Premium> paymentTypeAltPremiums = new HashMap<>();
                            if (quote.getPaymentTypeAltPremiums() != null && !quote.getPaymentTypeAltPremiums().isEmpty()) {
                                quote.getPaymentTypeAltPremiums().entrySet()
                                        .stream()
                                        .forEach(entry -> {
                                            paymentTypeAltPremiums.put(getPaymentType(entry.getKey()), createPremium(entry.getValue(), quote.getInfo(), request.getQuote(), policyTypeExists(quote.getHospital()), rebateChangeover, isSimplesUser));
                                        });
                            } else {
                                quote.getPaymentTypePremiums().entrySet()
                                        .stream()
                                        .forEach(entry -> {
                                            paymentTypeAltPremiums.put(getPaymentType(entry.getKey()), createPremium(createDefaultPremium(), quote.getInfo(), request.getQuote(), policyTypeExists(quote.getHospital()), rebateChangeover, isSimplesUser));
                                        });
                            }
                            result.setPaymentTypeAltPremiums(paymentTypeAltPremiums);
                        }
                    }

                    quote.getGiftCard().map(GiftCard::getAmount).ifPresent(result::setGiftCardAmount); //otherwise it will be null in order for web-ctm to parse correctly (web-ctm can't parse Optional.empty)

                    result.setInfo(createInfo(quote.getInfo(), index++));
                    result.setHospital(validateNode(quote.getHospital()));
                    JsonNode extras = validateNode(quote.getExtras());

                    // This is to support new Health Quote. Old Health Quote will have hasSpecialFeatures present so this won't be called
                    if(!extras.getClass().equals(TextNode.class) && !extras.has("hasSpecialFeatures")) {
                        ((ObjectNode) extras).put("hasSpecialFeatures", extras.get("SpecialFeatures").isNull() ? "N" : "Y");
                        ((ObjectNode) extras).set("SpecialFeatures", extras.get("SpecialFeatures") != null ? extras.get("SpecialFeatures").get("hasSpecialFeatures") : null);
                    }

                    result.setExtras(extras);
                    result.setAmbulance(validateNode(quote.getAmbulance()));
                    result.setAccident(validateNode(quote.getAccident()));

                    if (quote.isPriceChanged()) {
                        hasPriceChanged = true;
                    }
                    results.add(result);
                }

            }

            return new ResponseAdapterModel(hasPriceChanged, results,
                    ofNullable(healthResponse.getSummary())
                            .map(s -> SummaryResponseAdapterV2.adapt(request, s)));
        }
    }

    public static String getPaymentType(final PaymentType paymentType) {
        switch (paymentType) {
            case BANK:
                return "BankAccount";
            case CREDIT:
                return "CreditCard";
            case INVOICE:
                return "Invoice";
            default:
                throw new RuntimeException("Not supported paymentType " + paymentType);
        }
    }

    private static com.ctm.web.health.quote.model.response.Premium createDefaultPremium() {
        final com.ctm.web.health.quote.model.response.Premium premium =
                new com.ctm.web.health.quote.model.response.Premium();
        premium.setAnnually(DEFAULT_PRICE);
        premium.setFortnightly(DEFAULT_PRICE);
        premium.setMonthly(DEFAULT_PRICE);
        premium.setWeekly(DEFAULT_PRICE);
        premium.setHalfYearly(DEFAULT_PRICE);
        premium.setQuarterly(DEFAULT_PRICE);
        return premium;
    }

    private static JsonNode validateNode(final JsonNode jsonNode) {
        if (!jsonNode.isNull()) {
            return jsonNode;
        }
        return new TextNode("");
    }

    private static boolean policyTypeExists(final JsonNode jsonNode) {

        JsonNode nonNullNode = validateNode(jsonNode);
        if (nonNullNode.toString().length() > 2) {
            // This assumes that if the hospital node is an empty string it is an extras only policy, should the situation change the commented out line below should be sufficient
            //return !(nonNullNode.path("info").path("inclusions").path("cover").isNull());
            return true;
        }
        return false;
    }

    @VisibleForTesting static Promo createPromo(final Promotion quotePromotion, final String staticBranch, final boolean isSimplesUser, final String brandCode) {
        final Promo promo = new Promo();
        String staticBranchQS = staticBranch != null ? "&staticBranch=" + staticBranch : "";
        String brandCodeQS = brandCode != null && brandCode.length() > 0 ? "&brandCode=" + brandCode.toLowerCase() : "";

        promo.setPromoText(createPromoText(quotePromotion.getSpecialOffer(), isSimplesUser));

        if(quotePromotion.getSpecialOffer() != null){
            promo.setPromoTerms(quotePromotion.getSpecialOffer().getTerms());
            promo.setPromoDescription(quotePromotion.getSpecialOffer().getSummary());
        }

        promo.setProviderPhoneNumber(quotePromotion.getProviderPhoneNumber());
        promo.setProviderDirectPhoneNumber(quotePromotion.getProviderDirectPhoneNumber());
        promo.setDiscountText(StringUtils.trimToEmpty(quotePromotion.getDiscountDescription()));
        promo.setExtrasPDF(createPDFLink(quotePromotion.getExtrasPDF(), staticBranchQS, brandCodeQS));
        promo.setHospitalPDF(createPDFLink(quotePromotion.getHospitalPDF(), staticBranchQS, brandCodeQS));
        return promo;
    }

    private static String createPDFLink(final String pdfUrl, String staticBranchQS, String brandCodeQS) {

        if(pdfUrl == null) {
            return "";
        }

        if(pdfUrl.toLowerCase().contains(ATLAS_QUOTE_BROCHURE_IDENTIFIER)) {
            return pdfUrl;
        }else{
            return String.format(HEALTH_BROCHURE_URL, pdfUrl, staticBranchQS, brandCodeQS);
        }
    }

    private static AwardScheme createAwardScheme(final Promotion quotePromotion, boolean isSimplesUser) {
        final AwardScheme awardScheme = new AwardScheme();
        awardScheme.setText(createPromoText(quotePromotion.getAwardScheme(), isSimplesUser));
        return awardScheme;
    }

    private static Premium createPremium(final com.ctm.web.health.quote.model.response.Premium quotePremium,
                                         final com.ctm.web.health.quote.model.response.Info info,
                                         final com.ctm.web.health.model.form.HealthQuote healthQuote,
                                         final boolean lookingForPrivateHospitalCover, boolean isSimplesUser) {
        return createPremium(quotePremium, info, healthQuote, lookingForPrivateHospitalCover, empty(), isSimplesUser);
    }

    private static Premium createPremium(final com.ctm.web.health.quote.model.response.Premium quotePremium,
                                         final com.ctm.web.health.quote.model.response.Info info,
                                         final com.ctm.web.health.model.form.HealthQuote healthQuote,
                                         final boolean lookingForPrivateHospitalCover,
                                         final Optional<BigDecimal> rebatePercentage, boolean isSimplesUser) {
        final Premium premium = new Premium();
        premium.setAnnually(createPrice(quotePremium.getAnnually(), healthQuote, lookingForPrivateHospitalCover, rebatePercentage, isSimplesUser));
        premium.setMonthly(createPrice(quotePremium.getMonthly(), healthQuote, lookingForPrivateHospitalCover, rebatePercentage, isSimplesUser));
        premium.setFortnightly(createPrice(quotePremium.getFortnightly(), healthQuote, lookingForPrivateHospitalCover, rebatePercentage, isSimplesUser));
        premium.setWeekly(createPrice(quotePremium.getWeekly(), healthQuote, lookingForPrivateHospitalCover, rebatePercentage, isSimplesUser));
        premium.setHalfyearly(createPrice(quotePremium.getHalfYearly(), healthQuote, lookingForPrivateHospitalCover, rebatePercentage, isSimplesUser));
        premium.setQuarterly(createPrice(quotePremium.getQuarterly(), healthQuote, lookingForPrivateHospitalCover, rebatePercentage, isSimplesUser));
        return premium;
    }

    private static Price createPrice(final com.ctm.web.health.quote.model.response.Price quotePrice,
                                     final com.ctm.web.health.model.form.HealthQuote healthQuote,
                                     final boolean lookingForPrivateHospitalCover,
                                     final Optional<BigDecimal> rebatePercentage, boolean isSimplesUser) {

        if (quotePrice == null) return null;

        final Price price = new Price();

        final boolean hasDiscount = healthQuote.getApplyDiscounts().equals("Y") && quotePrice.getDiscountPercentage().compareTo(BigDecimal.ZERO) > 0;
        final String rebateValue = formatCurrency(calculateRebateValue(rebatePercentage, quotePrice.getBasePremium(), quotePrice.getRebateAmount()), true, true);

        price.setDiscounted(hasDiscount ? "Y" : "N");
        price.setDiscountAmount(formatCurrency(quotePrice.getDiscountAmount(), true, true));
        price.setDiscountPercentage(quotePrice.getDiscountPercentage());

        final BigDecimal lhcAmount = quotePrice.getLhcAmount();

        String pricingText = String.format("Includes rebate of %1$s & LHC loading of %2$s.", rebateValue, formatCurrency(lhcAmount, true, true)).trim();
        price.setPricing(pricingText);

        final BigDecimal lhcFreeAmount = calculateLHCFreeAmount(rebatePercentage, quotePrice.getBasePremium(), quotePrice.getLhcFreeAmount());
        price.setLhcfreetext(formatCurrency(lhcFreeAmount, true, true) + (hasDiscount && isSimplesUser ? "*" : ""));
        price.setLhcfreevalue(lhcFreeAmount);

        final BigDecimal payableAmount = quotePrice.getPayableAmount();
        price.setText(formatCurrency(payableAmount, true, true) + (hasDiscount && isSimplesUser ? "*" : ""));
        price.setValue(payableAmount);

        String lhcFreePricingText = String.format("%1$s inc %2$s Govt Rebate.", getLhcFreePricing(healthQuote, lhcAmount, lookingForPrivateHospitalCover), rebateValue).trim();
        price.setLhcfreepricing(lhcFreePricingText);

        price.setRebateValue(rebateValue);

        price.setBase(formatCurrency(quotePrice.getBasePremium(), true, true));
        price.setBaseAndLHC(formatCurrency(quotePrice.getBaseAndLHC(), true, true));

        price.setHospitalValue(quotePrice.getHospitalValue());
        price.setRebate(rebatePercentage.orElse(quotePrice.getRebatePercentage()));
        price.setLhcPercentage(healthQuote.getLoading());
        price.setLhc(formatCurrency(lhcAmount, true, true));
        price.setGrossPremium(formatCurrency(quotePrice.getGrossPremium(), true, true));

        price.setAbd(quotePrice.getAbd());
        price.setAbdValue(quotePrice.getAbdValue());
        return price;
    }

    private static String getLhcFreePricing(final com.ctm.web.health.model.form.HealthQuote healthQuote, final BigDecimal lhcAmount, final boolean lookingForPrivateHospitalCover) {
        HealthCover healthCover = healthQuote.getHealthCover();
        Insured primary = healthCover.getPrimary();
        Optional<Insured> partner = Optional.of(healthCover).map(HealthCover::getPartner).filter(i -> StringUtils.isNotBlank(i.getDob()));

        String lhcFreePricing = "";
        if (isInsuredAffectedByLHC(primary, lookingForPrivateHospitalCover) || partner.map(optionalPartner -> ResponseAdapterV2.isInsuredAffectedByLHC(optionalPartner, lookingForPrivateHospitalCover)).orElse(false)) {
            lhcFreePricing = "The premium may be affected by LHC";
        }

        return lhcFreePricing;
    }

    public static boolean isInsuredAffectedByLHC(Insured insured, boolean lookingForPrivateHospitalCover) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate insuredDob = LocalDate.parse(insured.getDob(), formatter);
        long insuredLHCDays = LHCDateCalculationSupport.getLhcDaysApplicable(insuredDob, LocalDate.now());

        return insuredLHCDays > 0 && lookingForPrivateHospitalCover;
    }

    protected static BigDecimal calculateRebateValue(final Optional<BigDecimal> rebate, final BigDecimal basePremium, final BigDecimal calculatedRebateValue) {
        return rebate.map(r -> basePremium.multiply(r.divide(new BigDecimal(100))).setScale(2, 4))
                .orElse(calculatedRebateValue);
    }

    protected static BigDecimal calculateLHCFreeAmount(final Optional<BigDecimal> rebate, final BigDecimal basePremium, final BigDecimal calculateLHCFreeAmount) {
        return rebate.map(r -> basePremium.multiply((new BigDecimal(100)).subtract(r).divide(new BigDecimal(100))).setScale(2, 4))
                .orElse(calculateLHCFreeAmount);
    }

    public static String formatCurrency(final BigDecimal value, final boolean showSymbol, final boolean groupingUsed) {
        final NumberFormat form;
        if (showSymbol) {
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

    private static String createPromoText(final SpecialOffer specialOffer, final boolean isSimplesUser) {
        final StringBuilder sb = new StringBuilder("");
        if (specialOffer != null) {
            sb.append(StringUtils.trimToEmpty(specialOffer.getSummary()));
            if (StringUtils.isNotBlank(specialOffer.getTerms())) {
                sb.append("<p>").append("<a class=\"dialogPop\" data-content=\"")
                        .append(StringEscapeUtils.escapeHtml4(specialOffer.getTerms()));

                if (isSimplesUser) {
                    sb.append("\" title=\"Terms and Conditions\"").append(" data-class=\"results-promo-modal\">").append("^ Terms and Conditions");
                } else {
                    sb.append("\" title=\"Find out more\"").append(" data-class=\"results-promo-modal\">").append("Find out more");
                }

                sb.append("</a>").append("</p>");
            }
        }
        return sb.toString();
    }

    private static Info createInfo(final com.ctm.web.health.quote.model.response.Info responseInfo, final int index) {
        final Info info = new Info();
        info.setRestrictedFund(responseInfo.isRestrictedFund() ? "Y" : "N");
        info.setProvider(responseInfo.getFundCode());
        info.setProviderName(responseInfo.getFundName());
        info.setProviderId(responseInfo.getProviderId());
        info.setProductCode(responseInfo.getProductCode());
        info.setHospitalName(responseInfo.getHospitalName());
        info.setExtrasName(responseInfo.getExtrasName());
        info.setFundProductCode(responseInfo.getFundProductCode());
        info.setProductTitle(responseInfo.getTitle());
        info.setTrackCode("UNKNOWN");
        info.setName(responseInfo.getName());
        info.setDes(responseInfo.getDescription());
        info.setRank(responseInfo.getRank());
        info.setOtherProductFeatures(responseInfo.getOtherProductFeatures());
        info.setSituationFilter(responseInfo.getSituationFilter());
        info.setExcess(responseInfo.getExcess());
        final Map<String, String> otherInfoProperties = responseInfo.getOtherInfoProperties();
        info.setCategory(otherInfoProperties.get("Category"));
        info.setFundCode(otherInfoProperties.get("FundCode"));
        info.setProductType(otherInfoProperties.get("ProductType"));
        info.setState(otherInfoProperties.get("State"));
        info.setPopularProduct(responseInfo.getPopularProduct());
        info.setPopularProductsRank(responseInfo.getPopularProductRank());
        info.setAbdRequestFlag(responseInfo.getAbdRequestFlag());
        return info;
    }
}
