package com.ctm.web.health.lhc.calculation;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

/**
 * DTO for encapsulating Permitted cover gap data.
 */
public class GapData {
    private final LocalDate firstPermittedGapDay;
    private final List<LocalDate> permittedGapDays;
    private final LocalDate lastPermittedGapDay;
    private final LocalDate firstNonPermittedGapDay;
    private final boolean hasExhaustedGapDays;
    private final int remainingGapDays;

    private GapData(LocalDate firstPermittedGapDay, List<LocalDate> permittedGapDays, LocalDate lastPermittedGapDay, LocalDate firstNonPermittedGapDay, boolean hasExhaustedGapDays, int remainingGapDays) {
        this.firstPermittedGapDay = firstPermittedGapDay;
        this.permittedGapDays = permittedGapDays;
        this.lastPermittedGapDay = lastPermittedGapDay;
        this.firstNonPermittedGapDay = firstNonPermittedGapDay;
        this.hasExhaustedGapDays = hasExhaustedGapDays;
        this.remainingGapDays = remainingGapDays;
    }


    public LocalDate getFirstPermittedGapDay() {
        return firstPermittedGapDay;
    }

    public List<LocalDate> getPermittedGapDays() {
        return permittedGapDays;
    }

    public LocalDate getLastPermittedGapDay() {
        return lastPermittedGapDay;
    }

    public LocalDate getFirstNonPermittedGapDay() {
        return firstNonPermittedGapDay;
    }

    public boolean hasExhaustedGapDays() {
        return hasExhaustedGapDays;
    }

    public int getRemainingGapDays() {
        return remainingGapDays;
    }

    /**
     * Builder implementation describing how to calculate fields for {@link GapData}.
     */
    public static final class Builder {
        private LocalDate lastDayOfFirstCover;
        private Set<LocalDate> allCoveredDays;
        private LocalDate calculationDate;

        public Builder lastDayOfFirstCover(LocalDate lastDayOfFirstCover) {
            this.lastDayOfFirstCover = lastDayOfFirstCover;
            return this;
        }

        public Builder allCoveredDays(Set<LocalDate> allCoveredDays) {
            this.allCoveredDays = allCoveredDays;
            return this;
        }

        public Builder when(LocalDate calculationDate) {
            this.calculationDate = calculationDate;
            return this;
        }

        public GapData createGapData() {
            LocalDate firstPermittedGapDay = LHCDateCalculationSupport.getFirstNonCoveredDay(lastDayOfFirstCover, calculationDate, allCoveredDays).orElse(calculationDate);
            List<LocalDate> permittedGapDays = LHCDateCalculationSupport.calculatePermittedGapDays(firstPermittedGapDay, calculationDate, allCoveredDays);
            LocalDate lastPermittedGapDay = permittedGapDays.isEmpty() ? firstPermittedGapDay : permittedGapDays.get(permittedGapDays.size() - 1);
            LocalDate firstNonPermittedGapDay = LHCDateCalculationSupport.getFirstNonCoveredDay(lastPermittedGapDay.plusDays(1), calculationDate, allCoveredDays).orElse(calculationDate);
            boolean hasExhaustedGapDays = permittedGapDays.size() == Constants.LHC_DAYS_WITHOUT_COVER_THRESHOLD;
            int remainingGapDays = Math.max(Constants.LHC_DAYS_WITHOUT_COVER_THRESHOLD - permittedGapDays.size(), 0);
            return new GapData(firstNonPermittedGapDay, permittedGapDays, lastPermittedGapDay, firstNonPermittedGapDay, hasExhaustedGapDays, remainingGapDays);
        }

    }
}
