package com.ctm.web.simples.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by voba on 15/09/2015.
 */
public class ChangeOverRebate {
    private BigDecimal currentMultiplier;
    private BigDecimal futureMultiplier;

    private Date effectiveStart;
    private Date effectiveFutureStart;

    public ChangeOverRebate() {

    }

    public ChangeOverRebate(BigDecimal currentMultiplier, BigDecimal futureMultiplier, Date effectiveStart) {
        this.currentMultiplier = currentMultiplier;
        this.futureMultiplier = futureMultiplier;
        this.effectiveStart = effectiveStart;
    }

    public Float getCurrentMultiplier() {
        return currentMultiplier.floatValue();
    }

    public void setCurrentMultiplier(BigDecimal currentMultiplier) {
        this.currentMultiplier = currentMultiplier;
    }

    public Float getFutureMultiplier() {
        return futureMultiplier.floatValue();
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
