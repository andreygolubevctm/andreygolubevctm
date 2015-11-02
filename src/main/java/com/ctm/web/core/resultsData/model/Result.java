package com.ctm.web.core.resultsData.model;


import static com.ctm.web.core.resultsData.model.AvailableType.Y;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */
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
