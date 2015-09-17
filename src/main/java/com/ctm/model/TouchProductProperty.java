package com.ctm.model;

public class TouchProductProperty extends AbstractTouchProperty {

    private String productCode;

    private String productName;

    private String providerCode;

    private String providerName;

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProviderCode() {
        return providerCode;
    }

    public void setProviderCode(String providerCode) {
        this.providerCode = providerCode;
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    @Override
    public String toString() {
        return "TouchProductProperty{" +
                "productCode='" + productCode + '\'' +
                ", productName='" + productName + '\'' +
                ", providerCode='" + providerCode + '\'' +
                ", providerName='" + providerName + '\'' +
                '}';
    }
}
