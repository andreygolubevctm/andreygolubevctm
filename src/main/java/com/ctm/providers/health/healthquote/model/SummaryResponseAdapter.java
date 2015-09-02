package com.ctm.providers.health.healthquote.model;

import com.ctm.model.health.form.HealthQuote;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.health.results.PremiumRange;
import com.ctm.model.health.results.Range;
import com.ctm.providers.health.healthquote.model.response.HealthSummaryResponse;
import com.ctm.providers.health.healthquote.model.response.PremiumsSummary;
import com.disc_au.price.health.PremiumCalculator;

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

    private static Range createRange(com.ctm.providers.health.healthquote.model.response.PremiumRange premiumRange, HealthQuote healthQuote) {
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
