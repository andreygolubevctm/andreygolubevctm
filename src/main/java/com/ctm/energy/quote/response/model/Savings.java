package com.ctm.energy.quote.response.model;


import java.math.BigDecimal;
import java.util.Optional;

public class Savings {

    BigDecimal quarterly;
    BigDecimal percentage;
    BigDecimal yearly;

    public Savings(BigDecimal quarterly, BigDecimal percentage, BigDecimal yearly) {
        this.quarterly = quarterly;
        this.percentage = percentage;
        this.yearly = yearly;
    }


    @SuppressWarnings("unused")
    private Savings(){

    }

    public BigDecimal getQuarterly() {
        return quarterly;
    }

    public BigDecimal getPercentage() {
        return percentage;
    }

    public Optional<BigDecimal> getYearly() {
        return Optional.ofNullable(yearly);
    }

}
