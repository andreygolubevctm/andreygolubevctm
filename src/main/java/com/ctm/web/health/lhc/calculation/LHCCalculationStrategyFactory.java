package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.ctm.web.health.lhc.model.response.LHCBaseDateDetails;

import java.time.LocalDate;

/**
 * Factory for creating instances of {@link LHCCalculationStrategy} from the given {@link LHCCalculationDetails}.
 *
 * @see LHCCalculationStrategy
 */
public class LHCCalculationStrategyFactory {

    /**
     * @param details the {@link LHCCalculationDetails}.
     * @param now
     * @return an instance of the applicable LHC calculation strategy.
     */
    public static LHCCalculationStrategy getInstance(LHCCalculationDetails details, LocalDate now) {
        LHCCalculationDetails lhcCalculationDetails = reapplyBaseDateCalculations(details);

        boolean agedLessThan31 = LHCDateCalculationSupport.calculateAgeInYearsFrom(lhcCalculationDetails.getDateOfBirth(), now) < Constants.LHC_EXEMPT_AGE_CUT_OFF;
        boolean bornOnOrBefore1934 = lhcCalculationDetails.getDateOfBirth().isBefore(Constants.LHC_BIRTHDAY_APPLICABILITY_DATE) ||
                lhcCalculationDetails.getDateOfBirth().isEqual(Constants.LHC_BIRTHDAY_APPLICABILITY_DATE);

        if (lhcCalculationDetails.getContinuousCover() || agedLessThan31 || bornOnOrBefore1934) {
            return new MinimumLHCCalculationStrategy();
        } else if (details.getNeverHadCover() || lhcCalculationDetails.getCoverDates().isEmpty()) {
            return new NeverHeldCoverCalculator(lhcCalculationDetails.getDateOfBirth(), now);
        } else {
            return new PreviouslyHeldCoverCalculationStrategy(lhcCalculationDetails.getDateOfBirth(), lhcCalculationDetails.getBaseDate(), lhcCalculationDetails.getCoverDates(), now);
        }
    }

    private static LHCCalculationDetails reapplyBaseDateCalculations(LHCCalculationDetails details) {
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(details.getDateOfBirth());
        return details.lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge());
    }
}
