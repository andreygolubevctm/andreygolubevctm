package com.ctm.model.health.results;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class InfoHealth extends com.ctm.model.resultsData.Info {

    private boolean pricesHaveChanged;

    private PremiumRange premiumRange;

    public boolean isPricesHaveChanged() {
        return pricesHaveChanged;
    }

    public void setPricesHaveChanged(boolean pricesHaveChanged) {
        this.pricesHaveChanged = pricesHaveChanged;
    }

    public PremiumRange getPremiumRange() {
        return premiumRange;
    }

    public void setPremiumRange(PremiumRange premiumRange) {
        this.premiumRange = premiumRange;
    }
}
