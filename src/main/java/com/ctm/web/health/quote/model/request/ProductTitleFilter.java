package com.ctm.web.health.quote.model.request;

public class ProductTitleFilter {

    private String productTitle;

    private boolean exact;

    public String getProductTitle() {
        return productTitle;
    }

    public void setProductTitle(String productTitle) {
        this.productTitle = productTitle;
    }

    public boolean isExact() {
        return exact;
    }

    public void setExact(boolean exact) {
        this.exact = exact;
    }
}
