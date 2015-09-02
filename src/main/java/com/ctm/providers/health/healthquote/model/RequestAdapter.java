package com.ctm.providers.health.healthquote.model;

import com.ctm.model.health.Frequency;
import com.ctm.model.health.Membership;
import com.ctm.model.health.form.*;
import com.ctm.providers.health.healthquote.model.request.*;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDate;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.ctm.model.health.HospitalSelection.BOTH;
import static com.ctm.model.health.HospitalSelection.PRIVATE_HOSPITAL;
import static com.ctm.model.health.ProductStatus.*;
import static java.util.Arrays.asList;

public class RequestAdapter {

    public static HealthQuoteRequest adapt(HealthRequest request) {

        final HealthQuote quote = request.getQuote();

        HealthQuoteRequest quoteRequest = new HealthQuoteRequest();

        final Filter filter = quote.getFilter();

        Filters filters = new Filters();
        if (filter != null) {
            quoteRequest.setFilters(filters);

            if (StringUtils.isNotBlank(filter.getTierHospital())) {
                int value = Integer.parseInt(filter.getTierHospital());
                if (value > 0) {
                    filters.setTierHospitalFilter(value);
                }
            }
            if (StringUtils.isNotBlank(filter.getTierExtras())) {
                int value = Integer.parseInt(filter.getTierExtras());
                if (value > 0) {
                    filters.setTierExtrasFilter(value);
                }
            }
            if (filter.getFrequency() != null && filter.getPriceMin() != null) {
                PriceFilter priceFilter = new PriceFilter();
                priceFilter.setFrequency(Frequency.findByCode(filter.getFrequency()));
                priceFilter.setBase(Double.parseDouble(filter.getPriceMin()));
                filters.setPriceFilter(priceFilter);
            }

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

        quoteRequest.setSearchResults(12);

        Situation situation = quote.getSituation();
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

        Map<String, String> benefitsExtras = quote.getBenefits().getBenefitsExtras();
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

        boolean isShowAll = StringUtils.equals(quote.getShowAll(), "Y");

        if (isShowAll) {
            quoteRequest.setSearchResults(12);
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
        } else {
            quoteRequest.setSearchResults(1);
            Application application = quote.getApplication();
            if (application != null) {
                if (StringUtils.isNotBlank(application.getProductTitle())) {
                    ProductTitleFilter productTitleFilter = new ProductTitleFilter();
                    productTitleFilter.setExact(true);
                    productTitleFilter.setProductTitle(application.getProductTitle());
                    filters.setProductTitleFilter(productTitleFilter);
                }
                if (StringUtils.isNotBlank(application.getProductId())) {
                    ProductIdSameExcessAmountFilter excessFilter = new ProductIdSameExcessAmountFilter();
                    String productId = application.getProductId();
                    if (StringUtils.startsWith(application.getProductId(), "PHIO-HEALTH-")) {
                         productId = StringUtils.remove(application.getProductId(), "PHIO-HEALTH-");
                    }
                    excessFilter.setProductIdWithSameExcessAmount(Integer.parseInt(productId));
                    filters.setExcessFilter(excessFilter);
                }
            }
        }

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

        quoteRequest.setExcludeStatus(asList(CALL_CENTRE, NOT_AVAILABLE, EXPIRED));

        filters.setPreferencesFilter(getPreferences(benefitsExtras));
        quoteRequest.setSearchDateValue(LocalDate.now());

        quoteRequest.setLoading(quote.getLoading());

        return quoteRequest;
    }

    private static boolean toBoolean(String value) {
        return StringUtils.equals("Y", value);
    }

    private static List<String> getPreferences(Map<String, String> benefitsExtras) {
        List<String> preferences = new ArrayList<>();
        for (String key : benefitsExtras.keySet()) {
            if (key.equals("HearingAid")) {
                preferences.add("HearingAids");
            } else if (key.equals("Naturopath")) {
                preferences.add("Naturopathy");
            } else {
                preferences.add(key);
            }
        }
        return preferences;

    }
}
