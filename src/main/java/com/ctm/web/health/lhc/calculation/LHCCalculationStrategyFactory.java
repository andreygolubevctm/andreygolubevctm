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
        LHCCalculationDetails updatedDetails = recalculateLHCDetails(details);
        if (updatedDetails.getContinuousCover() || updatedDetails.getLhcDaysApplicable() == 0) {
            return new AlwaysHeldContinuousCoverCalculator();
        } else if (details.getNeverHadCover()) {
            return new NeverHeldCoverCalculator(updatedDetails.getAge());
        } else {
            if (LHCDateCalculationSupport.heldCoverOnBaseDate(updatedDetails.getBaseDate(), updatedDetails.getCoverDates())) {
                return new HeldCoverOnBaseDateCalculator(updatedDetails.getLhcDaysApplicable(), updatedDetails.getCoverDates(), now);
            } else {
                return new NoCoverOnBaseDateCalculator(updatedDetails.getBaseDate(), updatedDetails.getCoverDates(), now);
            }
        }
    }

    private static LHCCalculationDetails recalculateLHCDetails(LHCCalculationDetails details) {
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(details.getDateOfBirth());
        return details.lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge());
    }
}
