package com.ctm.web.health.quote.model.response;

import java.math.BigDecimal;

public class GiftCard {

    private BigDecimal amount;

    private String previousProductId;

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(final BigDecimal amount) {
        this.amount = amount;
    }

    public String getPreviousProductId() {
        return previousProductId;
    }

    public void setPreviousProductId(final String previousProductId) {
        this.previousProductId = previousProductId;
    }
}
