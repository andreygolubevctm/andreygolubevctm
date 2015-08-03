package com.ctm.providers.car.carquote.model.request;

public class RiskAddress {

    private String fullAddressLineOne;

    private String streetNum;

    private String streetName;

    private String postCode;

    private String state;

    private String suburb;

    private String unitNumber;

    private String parkingType;

    public String getFullAddressLineOne() {
        return fullAddressLineOne;
    }

    public void setFullAddressLineOne(String fullAddressLineOne) {
        this.fullAddressLineOne = fullAddressLineOne;
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

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getSuburb() {
        return suburb;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }

    public String getUnitNumber() {
        return unitNumber;
    }

    public void setUnitNumber(String unitNumber) {
        this.unitNumber = unitNumber;
    }

    public String getParkingType() {
        return parkingType;
    }

    public void setParkingType(String parkingType) {
        this.parkingType = parkingType;
    }
}
