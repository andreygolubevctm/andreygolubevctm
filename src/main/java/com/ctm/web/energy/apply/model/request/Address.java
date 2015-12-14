package com.ctm.web.energy.apply.model.request;

import com.ctm.web.core.model.formData.YesNo;

public class Address {

    private String unitShop;
    private String unitType;
    private String streetNum;
    private String streetName;
    private String suburbName;
    private String state;
    private String postCode;
    private String nonStdUnitType;
    private String nonStdStreet;
    private String nonStdPostCode;
    private YesNo  nonStd;

    public String getUnitShop() {
        return unitShop;
    }

    public void setUnitShop(String unitShop) {
        this.unitShop = unitShop;
    }

    public String getStreetNum() {
        return streetNum;
    }

    public void setStreetNum(String streetNum) {
        this.streetNum = streetNum;
    }

    public String getStreetName() {
        return streetName;
    }

    public void setStreetName(String streetName) {
        this.streetName = streetName;
    }

    public String getSuburbName() {
        return suburbName;
    }

    public void setSuburbName(String suburbName) {
        this.suburbName = suburbName;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    public String getNonStdStreet() {
        return nonStdStreet;
    }

    public void setNonStdStreet(String nonStdStreet) {
        this.nonStdStreet = nonStdStreet;
    }

    public String getUnitType() {
        return unitType;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public String getNonStdUnitType() {
        return nonStdUnitType;
    }

    public void setNonStdUnitType(String nonStdUnitType) {
        this.nonStdUnitType = nonStdUnitType;
    }

    public String getNonStdPostCode() {
        return nonStdPostCode;
    }

    public void setNonStdPostCode(String nonStdPostCode) {
        this.nonStdPostCode = nonStdPostCode;
    }

    public YesNo getNonStd() {
        return nonStd;
    }

    public void setNonStd(YesNo nonStd) {
        this.nonStd = nonStd;
    }
}
