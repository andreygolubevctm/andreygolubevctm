package com.ctm.web.life.apply.model.request;


import javax.validation.Valid;
import javax.validation.constraints.NotNull;

public class Client {

    @NotNull
    @Valid
    private LifeApplyProduct product;

    public LifeApplyProduct getProduct() {
        return product;
    }

    public void setProduct(LifeApplyProduct product) {
        this.product = product;
    }

    public String getProductId() {
        return product.getId();
    }
}
