package com.ctm.model;

import static com.ctm.model.AvailableType.Y;

public class Result {

    private AvailableType available = Y;

    private String serviceName;

    private String productId;

    public AvailableType getAvailable() {
        return available;
    }

    public void setAvailable(AvailableType available) {
        this.available = available;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

}
