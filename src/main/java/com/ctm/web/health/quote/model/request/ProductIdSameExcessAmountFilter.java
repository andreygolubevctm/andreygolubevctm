package com.ctm.web.health.quote.model.request;

public class ProductIdSameExcessAmountFilter implements ExcessFilter {

    private int productIdWithSameExcessAmount;

    public int getProductIdWithSameExcessAmount() {
        return productIdWithSameExcessAmount;
    }

    public void setProductIdWithSameExcessAmount(int productIdWithSameExcessAmount) {
        this.productIdWithSameExcessAmount = productIdWithSameExcessAmount;
    }
}
