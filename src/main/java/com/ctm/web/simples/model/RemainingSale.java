package com.ctm.web.simples.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class RemainingSale {

    private String fundName;

    private int remainingSales;

    private int remainingDays;

    private RemainingSale(final Builder builder) {
        fundName = builder.fundName;
        remainingSales = getRemainingSales(builder.capLimit, builder.sales);
        remainingDays = getRemainingDays(builder.effectiveEnd, builder.compareDate, builder.sales, remainingSales);
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getFundName() {
        return fundName;
    }

    public int getRemainingSales() {
        return remainingSales;
    }

    public int getRemainingDays() {
        return remainingDays;
    }

    public static final class Builder {
        private String fundName;
        private LocalDate compareDate;
        private LocalDate effectiveStart;
        private LocalDate effectiveEnd;
        private int capLimit;
        private int sales;

        public Builder fundName(final String fundName) {
            this.fundName = fundName;
            return this;
        }

        public Builder effectiveStart(final LocalDate effectiveStart) {
            this.effectiveStart = effectiveStart;
            return this;
        }

        public Builder compareDate(final LocalDate compareDate) {
            this.compareDate = compareDate;
            return this;
        }

        public Builder effectiveEnd(final LocalDate effectiveEnd) {
            this.effectiveEnd = effectiveEnd;
            return this;
        }

        public Builder capLimit(final int capLimit) {
            this.capLimit = capLimit;
            return this;
        }

        public Builder sales(final int sales) {
            this.sales = sales;
            return this;
        }

        public RemainingSale build() {
            return new RemainingSale(this);
        }
    }

    protected int getRemainingSales(final int cappingLimit, final int sold) {
        return cappingLimit - sold;
    }

    protected int getRemainingDays(final LocalDate effectiveEnd, final LocalDate compareDate, final int sales, final int remainingSales) {

         if (effectiveEnd.isAfter(compareDate)) {

            final int comparedMonth = compareDate.getMonth().compareTo(effectiveEnd.getMonth());

            // Same month
            final int daysRemaining;
            if (comparedMonth == 0) {
                // how many more days until the effectiveEnd
                daysRemaining = effectiveEnd.getDayOfMonth() - compareDate.getDayOfMonth();
            } else {
                // how many more days remaining of the comparedDate
                daysRemaining = compareDate.lengthOfMonth() - compareDate.getDayOfMonth();
            }

            final BigDecimal averageSalesPerDay = new BigDecimal(sales)
                    .divide(new BigDecimal(compareDate.getDayOfMonth()), 0, BigDecimal.ROUND_CEILING);

            if (averageSalesPerDay.compareTo(BigDecimal.ZERO) != 0) {
                final int calculatedRemainingDay = new BigDecimal(remainingSales)
                        .divide(averageSalesPerDay, 0, BigDecimal.ROUND_CEILING)
                        .intValue();
                if (calculatedRemainingDay > daysRemaining) {
                    return daysRemaining;
                } else {
                    return calculatedRemainingDay;
                }
            } else {
                return daysRemaining;
            }

        }
        else {
            return 0;
        }
    }
}
