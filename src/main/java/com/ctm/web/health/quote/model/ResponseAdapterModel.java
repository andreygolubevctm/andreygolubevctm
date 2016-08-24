package com.ctm.web.health.quote.model;

import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.model.results.PremiumRange;

import java.util.List;
import java.util.Optional;

public class ResponseAdapterModel {

    private final boolean hasPriceChanged;

    private final List<HealthQuoteResult> results;

    private final Optional<PremiumRange> premiumRange;

    public ResponseAdapterModel(boolean hasPriceChanged, List<HealthQuoteResult> results, Optional<PremiumRange> premiumRange) {
        this.hasPriceChanged = hasPriceChanged;
        this.results = results;
        this.premiumRange = premiumRange;
    }

    public ResponseAdapterModel(boolean hasPriceChanged, List<HealthQuoteResult> results) {
        this.hasPriceChanged = hasPriceChanged;
        this.results = results;
        this.premiumRange = Optional.empty();
    }

    public boolean isHasPriceChanged() {
        return hasPriceChanged;
    }

    public List<HealthQuoteResult> getResults() {
        return results;
    }

    public Optional<PremiumRange> getPremiumRange() {
        return premiumRange;
    }
}
