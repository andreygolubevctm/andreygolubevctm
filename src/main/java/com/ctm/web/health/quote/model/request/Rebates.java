package com.ctm.web.health.quote.model.request;

import java.math.BigDecimal;

public class Rebates {

    private BigDecimal currentRebate;

    private BigDecimal futureRebate;

    private BigDecimal previousRebate;

    public BigDecimal getCurrentRebate() {
        return currentRebate;
    }

    public void setCurrentRebate(final BigDecimal currentRebate) {
        this.currentRebate = currentRebate;
    }

    public BigDecimal getFutureRebate() {
        return futureRebate;
    }

    public void setFutureRebate(final BigDecimal futureRebate) {
        this.futureRebate = futureRebate;
    }

    public BigDecimal getPreviousRebate() {
        return previousRebate;
    }

    public void setPreviousRebate(final BigDecimal previousRebate) {
        this.previousRebate = previousRebate;
    }
}
