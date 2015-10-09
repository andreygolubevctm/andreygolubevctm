package com.ctm.providers.health.healthquote.model;

import com.ctm.model.content.Content;
import com.ctm.model.health.Frequency;
import com.ctm.model.health.Membership;
import com.ctm.model.health.form.*;
import com.ctm.providers.health.healthquote.model.request.*;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.ctm.model.health.HospitalSelection.BOTH;
import static com.ctm.model.health.HospitalSelection.PRIVATE_HOSPITAL;
import static com.ctm.model.health.ProductStatus.*;
import static java.util.Arrays.asList;
import static java.util.Collections.singletonList;

public class RequestAdapter {

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static HealthQuoteRequest adapt(HealthRequest request) {
        return adapt(request, null);
    }

    public static HealthQuoteRequest adapt(HealthRequest request, Content alternatePricingContent) {

        HealthQuoteRequest quoteRequest = new HealthQuoteRequest();
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

        Map<String, String> benefitsExtras = quote.getBenefits().getBenefitsExtras();
        addProductType(quoteRequest, benefitsExtras);
        addHospitalSelection(quoteRequest, filters, benefitsExtras);
        filters.setPreferencesFilter(getPreferences(benefitsExtras));

        boolean isShowAll = toBoolean(quote.getShowAll());
        boolean isSimples = quote.getSimples() != null;
        boolean isDirectApplication = toBoolean(quote.getDirectApplication());
        addExcludeStatus(quoteRequest, isShowAll, isSimples);

        if (isShowAll) {
            // ShowAll returns a list of result
            if (quote.getSearchResults() != null) {
                quoteRequest.setSearchResults(quote.getSearchResults());
            } else {
                quoteRequest.setSearchResults(12);
            }
            addBoundedExcessFilter(quoteRequest, filters, quote);
            addProductTitleSearchFilter(filters, quote);
            addSingleProviderFilterFromSituation(filters, situation);
        } else {
            // returns a single result with the criteria below
            quoteRequest.setSearchResults(1);
            Application application = quote.getApplication();
            if (application != null) {
                addProductTitleSearchExactFilter(filters, application);
                addProductIdSameExcessAmountFilter(filters, application);
                addSingleProviderFilterFromApplication(filters, application);
            }
        }

        addCompareResultsFilter(filters, quote);
        addIncludeProductIfNotFound(filters, quote, isSimples, isDirectApplication);
        addCappingLimitFilter(filters, quote);

        addSearchDateFilter(quoteRequest, quote);

        quoteRequest.setLoading(quote.getLoading());

        addAlternatePricingFilter(alternatePricingContent, quoteRequest);

        addRebateFilter(quoteRequest, quote);

        return quoteRequest;
    }

    protected static void addRebateFilter(HealthQuoteRequest quoteRequest, HealthQuote quote) {
        if (quote.getRebate() != null) {
            quoteRequest.setRebate(new BigDecimal(quote.getRebate()));
        }
    }

    protected static void addAlternatePricingFilter(Content alternatePricingContent, HealthQuoteRequest quoteRequest) {
        if (alternatePricingContent != null && toBoolean(alternatePricingContent.getContentValue())) {
            quoteRequest.setIncludeAlternativePricing(true);
        }
    }

    protected static void addSearchDateFilter(HealthQuoteRequest quoteRequest, HealthQuote quote) {
        if (StringUtils.isNotBlank(quote.getSearchDate())) {
            quoteRequest.setSearchDateValue(LocalDate.parse(quote.getSearchDate(), AUS_FORMAT));
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
        if (quoteRequest.getProductType().equals("GeneralHealth")) {
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

    protected static void addHospitalSelection(HealthQuoteRequest quoteRequest, Filters filters, Map<String, String> benefitsExtras) {
        boolean isPrHospital = toBoolean(StringUtils.defaultIfEmpty(benefitsExtras.get("PrHospital"), "N"));
        boolean isPuHospital = toBoolean(StringUtils.defaultIfEmpty(benefitsExtras.get("PuHospital"), "N"));

        if (quoteRequest.getProductType().equals("GeneralHealth")) {
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
            quoteRequest.setProductType("Combined");
        } else if (hasHospitalBenefit) {
            quoteRequest.setProductType("Hospital");
        } else if (hasExtrasBenefit) {
            quoteRequest.setProductType("GeneralHealth");
        } else {
            quoteRequest.setProductType("Combined");
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

    protected static void addExcludeProvidersFilter(Filters filters, Filter filter) {
        if (StringUtils.isNotBlank(filter.getProviderExclude())) {
            ProviderFilter providerFilter = new ProviderFilter();
            ArrayList<Integer> providerIds = new ArrayList<>();
            providerFilter.setProviderIds(providerIds);
            providerFilter.setExclude(true);
            for (String code : StringUtils.split(filter.getProviderExclude(), ",")) {
                providerIds.add(HealthFund.valueOf(code).getId());
            }
            filters.setProviderFilter(providerFilter);
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
                default:
                    preferences.add(key);
                    break;
            }
        }
        return preferences;

    }

}
