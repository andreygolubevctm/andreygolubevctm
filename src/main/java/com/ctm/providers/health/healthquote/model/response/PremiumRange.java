package com.ctm.providers.health.healthquote.model.response;

import java.math.BigDecimal;

public class PremiumRange {

    private BigDecimal min;

    private BigDecimal max;

    public BigDecimal getMin() {
        return min;
    }

    public void setMin(BigDecimal min) {
        this.min = min;
    }

    public BigDecimal getMax() {
        return max;
    }

    public void setMax(BigDecimal max) {
        this.max = max;
    }
}
