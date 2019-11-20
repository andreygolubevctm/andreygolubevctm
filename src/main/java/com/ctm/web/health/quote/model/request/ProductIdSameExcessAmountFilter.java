package com.ctm.web.health.quote.model.request;

public class ProductIdSameExcessAmountFilter implements ExcessFilter {

    private String productIdWithSameExcessAmount;

    public String getProductIdWithSameExcessAmount() {
        return productIdWithSameExcessAmount;
    }

    public void setProductIdWithSameExcessAmount(String productIdWithSameExcessAmount) {
        this.productIdWithSameExcessAmount = productIdWithSameExcessAmount;
    }
}
