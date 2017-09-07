package com.ctm.web.simples.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by voba on 15/09/2015.
 */
public class ChangeOverRebate {
    private BigDecimal previousMultiplier;
    private BigDecimal currentMultiplier;
    private BigDecimal futureMultiplier;

    private Date effectiveStart;
    private Date effectiveFutureStart;

    public ChangeOverRebate() {

    }

    public ChangeOverRebate(BigDecimal previousMultiplier, BigDecimal currentMultiplier, BigDecimal futureMultiplier, Date effectiveStart) {
        this.previousMultiplier = previousMultiplier;
        this.currentMultiplier = currentMultiplier;
        this.futureMultiplier = futureMultiplier;
        this.effectiveStart = effectiveStart;
    }

    public BigDecimal getPreviousMultiplier() {
        return previousMultiplier;
    }

    public void setPreviousMultiplier(final BigDecimal previousMultiplier) {
        this.previousMultiplier = previousMultiplier;
    }

    public BigDecimal getCurrentMultiplier() {
        return currentMultiplier;
    }

    public void setCurrentMultiplier(BigDecimal currentMultiplier) {
        this.currentMultiplier = currentMultiplier;
    }

    public BigDecimal getFutureMultiplier() {
        return futureMultiplier;
    }

    public void setFutureMultiplier(BigDecimal futureMultiplier) {
        this.futureMultiplier = futureMultiplier;
    }

    public Date getEffectiveStart() {
        return effectiveStart;
    }

    public void setEffectiveStart(Date effectiveStart) {
        this.effectiveStart = effectiveStart;
    }

    public Date getEffectiveFutureStart() {
        return effectiveFutureStart;
    }

    public void setEffectiveFutureStart(Date effectiveFutureStart) {
        this.effectiveFutureStart = effectiveFutureStart;
    }
}
