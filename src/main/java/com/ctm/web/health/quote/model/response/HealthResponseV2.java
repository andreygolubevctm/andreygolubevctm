package com.ctm.web.health.quote.model.response;

import com.ctm.web.core.providers.model.IncomingQuotesResponse;

public class HealthResponseV2 extends IncomingQuotesResponse<HealthQuote> {

    private PremiumsSummary summary;

    public PremiumsSummary getSummary() {
        return summary;
    }

    public HealthResponseV2 setSummary(PremiumsSummary summary) {
        this.summary = summary;
        return this;
    }

}
