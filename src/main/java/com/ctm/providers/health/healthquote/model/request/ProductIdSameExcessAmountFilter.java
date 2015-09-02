package com.ctm.providers.health.healthquote.model.request;

public class ProductIdSameExcessAmountFilter implements ExcessFilter {

    private int productIdWithSameExcessAmount;

    public int getProductIdWithSameExcessAmount() {
        return productIdWithSameExcessAmount;
    }

    public void setProductIdWithSameExcessAmount(int productIdWithSameExcessAmount) {
        this.productIdWithSameExcessAmount = productIdWithSameExcessAmount;
    }
}
