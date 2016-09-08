package com.ctm.web.bsb.dao;

/**
 * Created by akhurana on 8/09/2016.
 */
public class BSBDetails {
    private String bsbNumber;
    private String branchName;
    private String address;
    private String suburb;
    private String postCode;
    private String state;


    public BSBDetails(String bsbNumber, String branchName, String address, String suburb, String postCode, String state) {
        this.bsbNumber = bsbNumber;
        this.branchName = branchName;
        this.address = address;
        this.suburb = suburb;
        this.postCode = postCode;
        this.state = state;
    }

    public String getBsbNumber() {
        return bsbNumber;
    }

    public void setBsbNumber(String bsbNumber) {
        this.bsbNumber = bsbNumber;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getSuburb() {
        return suburb;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
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

}
