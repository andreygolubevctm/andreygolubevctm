package com.ctm.web.health.quote.model;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.health.model.Frequency;
import com.ctm.web.health.model.Membership;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Benefits;
import com.ctm.web.health.model.form.Filter;
import com.ctm.web.health.model.form.HealthCover;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Payment;
import com.ctm.web.health.model.form.PaymentDetails;
import com.ctm.web.health.model.form.Situation;
import com.ctm.web.health.quote.model.abd.ABD;
import com.ctm.web.health.quote.model.abd.ABDDataAdapter;
import com.ctm.web.health.quote.model.request.*;
import com.ctm.web.simples.admin.model.capping.product.ProductCappingLimitCategory;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.ctm.web.core.utils.common.utils.LocalDateUtils.parseAUSLocalDate;
import static com.ctm.web.health.model.HospitalSelection.BOTH;
import static com.ctm.web.health.model.HospitalSelection.PRIVATE_HOSPITAL;
import static com.ctm.web.health.model.ProductStatus.CALL_CENTRE;
import static com.ctm.web.health.model.ProductStatus.EXPIRED;
import static com.ctm.web.health.model.ProductStatus.NOT_AVAILABLE;
import static com.ctm.web.health.model.ProductStatus.ONLINE;
import static java.util.Arrays.asList;
import static java.util.Collections.emptyMap;
import static java.util.Collections.singletonList;

public class RequestAdapterV2 {

    private static final Logger LOGGER = LoggerFactory.getLogger(RequestAdapterV2.class);

    public static HealthQuoteRequest adapt(HealthRequest request, Content alternatePricingContent, boolean isSimples, final boolean isGiftCardActive) {

        HealthQuoteRequest quoteRequest = new HealthQuoteRequest();

        quoteRequest.setIsSimples(isSimples);

        Filters filters = new Filters();
        quoteRequest.setFilters(filters);

        final HealthQuote quote = request.getQuote();
        final Filter filter = quote.getFilter();
        if (filter != null) {

            addTierHospitalFilter(filters, filter);
            addTierExtrasFilter(filters, filter);
            addPriceFilter(filters, filter);
            // Set the excluded providers, but this will be overridden by
            // @see #addSingleProviderFilterFromSituation or by @see #addSingleProviderFilterFromApplication
            addExcludeProvidersFilter(filters, filter);

        }

        Situation situation = quote.getSituation();
        addMembership(quoteRequest, situation);
        Map<String, String> benefitsExtras = Optional.ofNullable(quote)
                .map(HealthQuote::getBenefits)
                .map(Benefits::getBenefitsExtras)
                .orElse(emptyMap());
        addProductType(quoteRequest, benefitsExtras);
        addSituationFilter(filters, situation, quoteRequest);
        addHospitalSelection(quoteRequest, filters, benefitsExtras, situation);
        filters.setPreferencesFilter(getPreferences(benefitsExtras));

        boolean isShowAll = toBoolean(quote.getShowAll());
        boolean isDirectApplication = toBoolean(quote.getDirectApplication());
        addExcludeStatus(quoteRequest, isShowAll, isSimples);

        if (isShowAll) {
            // ShowAll returns a list of result
            if (quote.getSearchResults() != null) {
                quoteRequest.setSearchResults(quote.getSearchResults());
            } else {
                if (isSimples) {
                    quoteRequest.setSearchResults(18);
                } else {
                    quoteRequest.setSearchResults(12);
                }
            }
            addBoundedExcessFilter(quoteRequest, filters, quote);
            addProductTitleSearchFilter(filters, quote);
            addSingleProviderFilterFromSituation(filters, situation);
            addApplyDiscountsFilter(filters, quote);
        } else {
            // returns a single result with the criteria below
            quoteRequest.setSearchResults(1);
            Application application = quote.getApplication();
            if (application != null) {
                addProductTitleSearchExactFilter(filters, application);
                addProductIdSameExcessAmountFilter(filters, application);
                addSingleProviderFilterFromApplication(filters, application);

                if (HealthFund.valueOf(application.getProvider()) == HealthFund.CBH) {
                    quoteRequest.setPaymentTypes(asList(PaymentType.BANK, PaymentType.INVOICE));
                } else {
                    quoteRequest.setPaymentTypes(asList(PaymentType.BANK, PaymentType.CREDIT));
                }
                filters.setApplyDiscounts(true);
            }
        }

        addCompareResultsFilter(filters, quote);
        addIncludeProductIfNotFound(filters, quote, isSimples, isDirectApplication);
        addCappingLimitFilter(filters, quote);
        addProductCappingLimitFilter(filters, quote);

        addSearchDateFilter(quoteRequest, quote, isShowAll);

        quoteRequest.setLoading(quote.getLoading());

        addAlternatePricingFilter(alternatePricingContent, quoteRequest);

        addRebateFilter(quoteRequest, quote);

        addPopularProductsFilter(filters, quote);

        addLimitToRewardsSchemeFilter(filters, quote);

        quoteRequest.setIncludeSummary(isSimples);

        quoteRequest.setIncludeGiftCard(isGiftCardActive);

        HealthCover cover = quote.getHealthCover();
        if (cover != null && cover.getPrimary() != null) {
            quoteRequest.setPrimaryHealthCover(toBoolean(cover.getPrimary().getCover()));
        } else {
            quoteRequest.setPrimaryHealthCover(null);
        }

        if (cover != null && cover.getPartner() != null) {
            quoteRequest.setPartnerHealthCover(toBoolean(cover.getPartner().getCover()));
        } else {
            quoteRequest.setPartnerHealthCover(null);
        }
        addPrimaryAge(quoteRequest, cover);
        addFamilyType(quoteRequest, situation);

        if (request.getHealth().getProductCode() != null && !request.getHealth().getProductCode().isEmpty()) {
            quoteRequest.setProductCode(request.getHealth().getProductCode());
        }

        ABDDataAdapter data = ABDDataAdapter.create(quote, request, isSimples);
        Optional<LocalDate> optionalPrimaryApplicantDateOfBirth = data.getPrimaryApplicantDob();
        if (ABD.APPLICABLE_PRODUCT_TYPES.contains(quoteRequest.getProductType()) && optionalPrimaryApplicantDateOfBirth.isPresent()) {
            LocalDate primaryApplicantDateOfBirth = optionalPrimaryApplicantDateOfBirth.get();
            LocalDate assessmentDate = quoteRequest.getSearchDateValue();


            Optional<LocalDate> primaryABDStart = data.getPrimaryPreviousPolicyStart();
            AbdDetails primaryABD = ABD.processABD(primaryApplicantDateOfBirth, assessmentDate, primaryABDStart);

            Optional<LocalDate> partnerABDStart = data.getPartnerPreviousPolicyStart();
            Optional<AbdDetails> partnerABD = data.getPartnerApplicantDob().map(dob -> ABD.processABD(dob, assessmentDate, partnerABDStart));

            int abdPercentage = Math.min((primaryABD.getAgeBasedDiscountPercentage() + partnerABD.map(AbdDetails::getAgeBasedDiscountPercentage).orElse(0)) / (partnerABD.isPresent() ? 2 : 1), 0);

            int rabdPercentage = Math.min(((primaryABD.getAgeBasedDiscountPercentage() - primaryABD.getRetainedAgeBasedDiscountPercentage()) + (partnerABD.map(a -> a.getAgeBasedDiscountPercentage() - a.getRetainedAgeBasedDiscountPercentage()).orElse(0))) / (partnerABD.isPresent() ? 2 : 1), 0);

            AbdSummary abdSummary = new AbdSummary();
            abdSummary.setAbd(abdPercentage);
            abdSummary.setRabd(rabdPercentage);
            abdSummary.setAssessmentDate(assessmentDate);
            abdSummary.setPrimary(primaryABD);
            partnerABD.ifPresent(abdSummary::setPartner);


            quoteRequest.setAbdSummary(abdSummary);

            quoteRequest.setAbdPercentage(abdPercentage);
            quoteRequest.setRabdPercentage(rabdPercentage);

        }

        return quoteRequest;
    }


    protected static void addPrimaryAge(HealthQuoteRequest quoteRequest, HealthCover healthCover) {
        try {
            if (healthCover != null && healthCover.getPrimary() != null) {
                quoteRequest.setAge(DateUtils.getAgeFromDOBStr(healthCover.getPrimary().getDob()));
            }
        } catch (Exception exception) {
            LOGGER.error("Cannot cover date of birth to age: " + healthCover.getPrimary().getDob());
        }
    }

    protected static void addFamilyType(HealthQuoteRequest quoteRequest, Situation situation) {
        if (situation != null) {
            quoteRequest.setFamilyType(situation.getHealthCvr());
        }
    }

    protected static void addRebateFilter(HealthQuoteRequest quoteRequest, HealthQuote quote) {
        if (quote.getRebate() != null) {
            final Rebates rebates = new Rebates();
            rebates.setCurrentRebate(new BigDecimal(quote.getRebate()));

            if (quote.getRebateChangeover() != null) {
                rebates.setFutureRebate(new BigDecimal(quote.getRebateChangeover()));
            }

            if (quote.getPreviousRebate() != null) {
                rebates.setPreviousRebate(new BigDecimal(quote.getPreviousRebate()));
            }

            quoteRequest.setRebates(rebates);
        }
    }

    protected static void addAlternatePricingFilter(Content alternatePricingContent, HealthQuoteRequest quoteRequest) {
        if (alternatePricingContent != null && toBoolean(alternatePricingContent.getContentValue())) {
            quoteRequest.setIncludeAlternativePricing(true);
        }
    }

    protected static void addSearchDateFilter(HealthQuoteRequest quoteRequest, HealthQuote quote, boolean isShowAll) {
        final Optional<String> paymentStartDate = Optional.ofNullable(quote.getPayment()).map(Payment::getDetails).map(PaymentDetails::getStart);
        // Use only paymentStartDate if doing update premium
        if (!isShowAll && paymentStartDate.isPresent() && StringUtils.isNotBlank(paymentStartDate.get())) {
            quoteRequest.setSearchDateValue(parseAUSLocalDate(paymentStartDate.get()));
        } else if (StringUtils.isNotBlank(quote.getSearchDate())) {
            quoteRequest.setSearchDateValue(parseAUSLocalDate(quote.getSearchDate()));
        } else {
            quoteRequest.setSearchDateValue(LocalDate.now());
        }
    }

    protected static void addCappingLimitFilter(Filters filters, HealthQuote quote) {
        if (toBoolean(quote.getOnResultsPage())) {
            filters.setCappingLimitFilter(CappingLimit.SOFT);
        } else {
            filters.setCappingLimitFilter(CappingLimit.HARD);
        }
    }

    protected static void addProductCappingLimitFilter(Filters filters, HealthQuote quote) {
        if (toBoolean(quote.getOnResultsPage())) {
            filters.setProductCappingLimitFilter(ProductCappingLimitCategory.SOFT);
        } else {
            filters.setProductCappingLimitFilter(ProductCappingLimitCategory.HARD);
        }
    }

    protected static void addIncludeProductIfNotFound(Filters filters, HealthQuote quote, boolean isSimples, boolean isDirectApplication) {
        if (isSimples || isDirectApplication) {
            Application application = quote.getApplication();
            if (application != null && StringUtils.isNotBlank(application.getProductId())) {
                IncludeProductIfNotFound includeProductIfNotFound = new IncludeProductIfNotFound();
                includeProductIfNotFound.setProductTitle(application.getProductTitle());
                includeProductIfNotFound.setProductId(getProductId(application));
                includeProductIfNotFound.setProviderId(HealthFund.valueOf(application.getProvider()).getId());
                filters.setIncludeProductIfNotFound(includeProductIfNotFound);
            }
        }
    }

    protected static void addCompareResultsFilter(Filters filters, HealthQuote quote) {
        if (quote.getRetrieve() != null && toBoolean(quote.getRetrieve().getSavedResults())) {
            CompareResultsFilter compareResultsFilter = new CompareResultsFilter();
            compareResultsFilter.setTransactionId(quote.getRetrieve().getTransactionId());
            filters.setCompareResultsFilter(compareResultsFilter);
        }
    }

    protected static void addSingleProviderFilterFromApplication(Filters filters, Application application) {
        if (StringUtils.isNotBlank(application.getProvider())) {
            ProviderFilter providerFilter = new ProviderFilter();
            providerFilter.setProviderIds(singletonList(HealthFund.valueOf(application.getProvider()).getId()));
            providerFilter.setExclude(false);
            filters.setProviderFilter(providerFilter);
        }
    }

    protected static void addProductIdSameExcessAmountFilter(Filters filters, Application application) {
        if (StringUtils.isNotBlank(application.getProductId())) {
            ProductIdSameExcessAmountFilter excessFilter = new ProductIdSameExcessAmountFilter();
            excessFilter.setProductIdWithSameExcessAmount(getProductId(application));
            filters.setExcessFilter(excessFilter);
        }
    }

    protected static void addProductTitleSearchExactFilter(Filters filters, Application application) {
        if (StringUtils.isNotBlank(application.getProductTitle())) {
            ProductTitleFilter productTitleFilter = new ProductTitleFilter();
            productTitleFilter.setExact(true);
            productTitleFilter.setProductTitle(application.getProductTitle());
            filters.setProductTitleFilter(productTitleFilter);
        }
    }

    protected static void addSingleProviderFilterFromSituation(Filters filters, Situation situation) {
        if (situation != null && StringUtils.isNotBlank(situation.getSingleProvider())) {
            ProviderFilter providerFilter = new ProviderFilter();
            providerFilter.setProviderIds(singletonList(Integer.parseInt(situation.getSingleProvider())));
            providerFilter.setExclude(false);
            filters.setProviderFilter(providerFilter);
        }
    }

    protected static void addProductTitleSearchFilter(Filters filters, HealthQuote quote) {
        if (StringUtils.isNotBlank(quote.getProductTitleSearch())) {
            ProductTitleFilter productTitleFilter = new ProductTitleFilter();
            productTitleFilter.setProductTitle(quote.getProductTitleSearch());
            productTitleFilter.setExact(false);
            filters.setProductTitleFilter(productTitleFilter);
        }
    }

    protected static void addBoundedExcessFilter(HealthQuoteRequest quoteRequest, Filters filters, HealthQuote quote) {
        BoundedExcessFilter boundedExcessFilter = new BoundedExcessFilter();
        filters.setExcessFilter(boundedExcessFilter);
        if (quoteRequest.getProductType() == ProductType.GENERALHEALTH) {
            boundedExcessFilter.setExcessMax(99999);
            boundedExcessFilter.setExcessMin(0);
        } else {
            switch (quote.getExcess()) {
                case "1":
                    boundedExcessFilter.setExcessMax(0);
                    boundedExcessFilter.setExcessMin(0);
                    break;
                case "2":
                    boundedExcessFilter.setExcessMax(250);
                    boundedExcessFilter.setExcessMin(1);
                    break;
                case "3":
                    boundedExcessFilter.setExcessMax(500);
                    boundedExcessFilter.setExcessMin(251);
                    break;
                case "5":
                    boundedExcessFilter.setExcessMax(750);
                    boundedExcessFilter.setExcessMin(501);
                    break;
                case "6":
                    boundedExcessFilter.setExcessMax(99999);
                    boundedExcessFilter.setExcessMin(751);
                    break;
                default:
                    boundedExcessFilter.setExcessMax(99999);
                    boundedExcessFilter.setExcessMin(0);
                    break;
            }
        }
    }

    protected static void addExcludeStatus(HealthQuoteRequest quoteRequest, boolean isShowAll, boolean isSimples) {
        if (isSimples && !isShowAll) {
            quoteRequest.setExcludeStatus(asList(NOT_AVAILABLE, EXPIRED));
        } else if (isSimples) {
            quoteRequest.setExcludeStatus(asList(ONLINE, NOT_AVAILABLE, EXPIRED));
        } else {
            quoteRequest.setExcludeStatus(asList(CALL_CENTRE, NOT_AVAILABLE, EXPIRED));
        }
    }

    protected static void addHospitalSelection(HealthQuoteRequest quoteRequest, Filters filters, Map<String, String> benefitsExtras, Situation situation) {
        boolean isPrHospital = toBoolean(StringUtils.defaultIfEmpty(benefitsExtras.get("PrHospital"), "N"));
        boolean isPuHospital = toBoolean(StringUtils.defaultIfEmpty(benefitsExtras.get("PuHospital"), "N"));

        if (quoteRequest.getProductType() == ProductType.GENERALHEALTH || (situation != null && toBoolean(situation.getAccidentOnlyCover()))) {
            quoteRequest.setHospitalSelection(BOTH);
        } else if (!isPrHospital && !isPuHospital) {
            if (filters.getTierHospitalFilter() != null && filters.getTierHospitalFilter() == 1) {
                quoteRequest.setHospitalSelection(BOTH);
            } else {
                quoteRequest.setHospitalSelection(PRIVATE_HOSPITAL);
            }
        } else if (isPrHospital) {
            quoteRequest.setHospitalSelection(PRIVATE_HOSPITAL);
        } else {
            quoteRequest.setHospitalSelection(BOTH);
        }
    }

    protected static void addProductType(HealthQuoteRequest quoteRequest, Map<String, String> benefitsExtras) {
        boolean hasHospitalBenefit = toBoolean(StringUtils.defaultIfEmpty(benefitsExtras.get("Hospital"), "N"));
        boolean hasExtrasBenefit = toBoolean(StringUtils.defaultIfEmpty(benefitsExtras.get("GeneralHealth"), "N"));
        if (hasHospitalBenefit && hasExtrasBenefit) {
            quoteRequest.setProductType(ProductType.COMBINED);
        } else if (hasHospitalBenefit) {
            quoteRequest.setProductType(ProductType.HOSPITAL);
        } else if (hasExtrasBenefit) {
            quoteRequest.setProductType(ProductType.GENERALHEALTH);
        } else {
            quoteRequest.setProductType(ProductType.COMBINED);
        }
    }

    protected static Situation addMembership(HealthQuoteRequest quoteRequest, Situation situation) {
        if (situation != null) {
            if (StringUtils.equals(situation.getState(), "ACT")) {
                quoteRequest.setState("NSW");
            } else {
                quoteRequest.setState(situation.getState());
            }
            if (StringUtils.equalsIgnoreCase("SPF", situation.getHealthCvr())) {
                quoteRequest.setMembership(Membership.SINGLE_PARENT);
            } else if (StringUtils.equalsIgnoreCase("SM", situation.getHealthCvr()) ||
                    StringUtils.equalsIgnoreCase("SF", situation.getHealthCvr())) {
                quoteRequest.setMembership(Membership.SINGLE);
            } else {
                quoteRequest.setMembership(Membership.findByCode(situation.getHealthCvr()));
            }
        }
        return situation;
    }

    protected static void addSituationFilter(Filters filters, Situation situation, HealthQuoteRequest quoteRequest) {
        if (situation != null && StringUtils.isNotBlank(situation.getAccidentOnlyCover())) {
            filters.setSituationFilter(toBoolean(situation.getAccidentOnlyCover()) &&
                    !(quoteRequest.getProductType() == ProductType.GENERALHEALTH));
        }
    }

    protected static void addExcludeProvidersFilter(Filters filters, Filter filter) {
        if (StringUtils.isNotBlank(filter.getProviderExclude())) {
            ProviderFilter providerFilter = new ProviderFilter();
            ArrayList<Integer> providerIds = new ArrayList<>();
            providerFilter.setProviderIds(providerIds);
            providerFilter.setExclude(true);
            for (String code : StringUtils.split(filter.getProviderExclude(), ",")) {
                try {
                    providerIds.add(HealthFund.valueOf(code).getId());
                } catch (IllegalArgumentException e) {
                    LOGGER.warn("Error while getting health fund", e);
                }
            }
            if (!providerIds.isEmpty()) {
                filters.setProviderFilter(providerFilter);
            }
        }
    }

    protected static void addPriceFilter(Filters filters, Filter filter) {
        if (filter.getFrequency() != null && filter.getPriceMin() != null) {
            PriceFilter priceFilter = new PriceFilter();
            priceFilter.setFrequency(Frequency.findByCode(filter.getFrequency()));
            priceFilter.setBase(Double.parseDouble(filter.getPriceMin()));
            filters.setPriceFilter(priceFilter);
        }
    }

    protected static void addTierExtrasFilter(Filters filters, Filter filter) {
        if (StringUtils.isNotBlank(filter.getTierExtras())) {
            int value = Integer.parseInt(filter.getTierExtras());
            if (value > 0) {
                filters.setTierExtrasFilter(value);
            }
        }
    }

    protected static void addTierHospitalFilter(Filters filters, Filter filter) {
        if (StringUtils.isNotBlank(filter.getTierHospital())) {
            int value = Integer.parseInt(filter.getTierHospital());
            if (value > 0) {
                filters.setTierHospitalFilter(value);
            }
        }
    }

    protected static Integer getProductId(Application application) {
        String productId = application.getProductId();
        if (StringUtils.startsWith(application.getProductId(), "PHIO-HEALTH-")) {
            productId = StringUtils.remove(application.getProductId(), "PHIO-HEALTH-");
        }
        return Integer.parseInt(productId);
    }

    protected static boolean toBoolean(String value) {
        return StringUtils.equals("Y", value);
    }

    protected static List<String> getPreferences(Map<String, String> benefitsExtras) {
        List<String> preferences = new ArrayList<>();
        for (String key : benefitsExtras.keySet()) {
            switch (key) {
                case "HearingAid":
                    preferences.add("HearingAids");
                    break;
                case "Naturopath":
                    preferences.add("Naturopathy");
                    break;
                case "PrHospital":
                    preferences.add("PrivateHospital");
                    break;
                case "GeneralHealth":
                case "Hospital":
                    break;
                default:
                    preferences.add(key);
                    break;
            }
        }
        return preferences;

    }

    protected static void addApplyDiscountsFilter(Filters filters, final HealthQuote quote) {
        if (quote.getApplyDiscounts() != null && quote.getApplyDiscounts().equals("Y")) {
            filters.setApplyDiscounts(true);
        } else {
            filters.setApplyDiscounts(false);
        }
    }

    protected static void addPopularProductsFilter(Filters filters, final HealthQuote quote) {
        boolean isPopularProducts = Optional.ofNullable(quote.getPopularProducts()).map(BooleanUtils::toBoolean).orElse(false);
        filters.setPopularProducts(isPopularProducts);
    }

    protected static void addLimitToRewardsSchemeFilter(Filters filters, final HealthQuote quote) {
        Boolean applyRewardsSchemeFilter = Optional.ofNullable(quote.getRewardsSchemeFirst()).map(BooleanUtils::toBoolean).orElse(false);
        filters.setLimitToProvidersWithRewardsSchemeFilter(applyRewardsSchemeFilter);
    }
}
