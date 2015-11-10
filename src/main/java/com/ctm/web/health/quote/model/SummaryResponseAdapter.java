package com.ctm.web.health.quote.model;

import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.PremiumRange;
import com.ctm.web.health.model.results.Range;
import com.ctm.web.health.price.PremiumCalculator;
import com.ctm.web.health.quote.model.response.HealthSummaryResponse;
import com.ctm.web.health.quote.model.response.PremiumsSummary;

import java.math.BigDecimal;

public class SummaryResponseAdapter {

    public static PremiumRange adapt(HealthRequest request, HealthSummaryResponse summaryResponse) {
        PremiumsSummary premiumsSummary = summaryResponse.getPayload().getQuotes().get(0);
        PremiumRange range = new PremiumRange();
        HealthQuote healthQuote = request.getQuote();
        range.setYearly(createRange(premiumsSummary.getYearlyPremiumRange(), healthQuote));
        range.setMonthly(createRange(premiumsSummary.getMonthlyPremiumRange(), healthQuote));
        range.setFortnightly(createRange(premiumsSummary.getFortnightlyPremiumRange(), healthQuote));
        return range;
    }

    private static Range createRange(com.ctm.web.health.quote.model.response.PremiumRange premiumRange, HealthQuote healthQuote) {
        Range range = new Range();
        range.setMax(calculatePriceFilterPremium(premiumRange.getMax().doubleValue(), healthQuote.getRebate()).intValue());
        range.setMin(calculatePriceFilterPremium(premiumRange.getMin().doubleValue(), healthQuote.getRebate()).intValue());
        return range;
    }

    private static BigDecimal calculatePriceFilterPremium(double basePremium, double rebate) {
        PremiumCalculator premiumCalculator = new PremiumCalculator();

        premiumCalculator.setRebate(rebate);
        premiumCalculator.setBasePremium(basePremium);

        // Get premium with rebate applied to it as is shown on the results page
        BigDecimal premium = premiumCalculator.getLHCFreeValueDecimal();

        // Round down to the nearest $5
        BigDecimal five = new BigDecimal(5);
        return premium.divide(five).setScale(0, BigDecimal.ROUND_DOWN).multiply(five);
    }

}
