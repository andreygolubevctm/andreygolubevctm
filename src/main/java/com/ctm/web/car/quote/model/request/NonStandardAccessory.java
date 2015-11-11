package com.ctm.web.car.quote.model.request;

import java.io.Serializable;
import java.math.BigDecimal;

public class NonStandardAccessory implements Serializable {

    private Boolean includedInPurchasePrice;

    private BigDecimal price;

    private String code;

    public boolean getIncludedInPurchasePrice() {
        return includedInPurchasePrice;
    }

    public void setIncludedInPurchasePrice(boolean includedInPurchasePrice) {
        this.includedInPurchasePrice = includedInPurchasePrice;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

}
