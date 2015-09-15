package com.ctm.model.simples;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by voba on 15/09/2015.
 */
public class ChangeOverRebate {
    private BigDecimal currentMultiplier;
    private BigDecimal futureMultiplier;

    private Date effectiveStart;
    private Date effectiveEnd;

    public ChangeOverRebate() {

    }

    public ChangeOverRebate(BigDecimal currentMultiplier, BigDecimal futureMultiplier, Date effectiveStart, Date effectiveEnd) {
        this.currentMultiplier = currentMultiplier;
        this.futureMultiplier = futureMultiplier;
        this.effectiveStart = effectiveStart;
        this.effectiveEnd = effectiveEnd;
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

    public Date getEffectiveEnd() {
        return effectiveEnd;
    }

    public void setEffectiveEnd(Date effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }
}
