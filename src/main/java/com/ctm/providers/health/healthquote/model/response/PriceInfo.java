package com.ctm.providers.health.healthquote.model.response;

import java.math.BigDecimal;

public abstract class PriceInfo {

    private BigDecimal rebateAmount;

    private BigDecimal lhcFreeAmount;

    public BigDecimal getRebateAmount() {
        return rebateAmount;
    }

    public void setRebateAmount(BigDecimal rebateAmount) {
        this.rebateAmount = rebateAmount;
    }

    public BigDecimal getLhcFreeAmount() {
        return lhcFreeAmount;
    }

    public void setLhcFreeAmount(BigDecimal lhcFreeAmount) {
        this.lhcFreeAmount = lhcFreeAmount;
    }
}
