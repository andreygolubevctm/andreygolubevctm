package com.ctm.web.life.apply.model.request;


import com.ctm.web.core.model.formData.YesNo;


public class LifeApplyPartner {

    private YesNo quote;

    private LifeApplyProduct product;

    public LifeApplyProduct getProduct() {
        return product;
    }

    public void setProduct(LifeApplyProduct product) {
        this.product = product;
    }

    public YesNo getQuote() {
        return quote;
    }

    public void setQuote(YesNo quote) {
        this.quote = quote;
    }

    public String getProductId() {
        return product != null ? product.getId() :  null;
    }
}
