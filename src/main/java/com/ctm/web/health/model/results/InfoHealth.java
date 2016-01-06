package com.ctm.web.health.model.results;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class InfoHealth extends com.ctm.web.core.resultsData.model.Info {

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
