package com.ctm.model;

/**
 * Created by bthompson on 26/06/2015.
 */
public class LmiModel {

    private String brandId;
    private String brandName;
    private boolean isInCtm;

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getBrandId() {
        return brandId;
    }

    public void setBrandId(String brandId) {
        this.brandId = brandId;
    }

    public boolean isInCtm() {
        return isInCtm;
    }

    public void setIsInCtm(boolean isInCtm) {
        this.isInCtm = isInCtm;
    }
}
