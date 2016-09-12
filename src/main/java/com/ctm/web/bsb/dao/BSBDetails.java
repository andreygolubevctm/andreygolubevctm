package com.ctm.web.bsb.dao;

/**
 * Created by akhurana on 8/09/2016.
 */
public class BSBDetails {
    private String bsbNumber;
    private String bankCode;
    private String branchName;
    private String address;
    private String suburb;
    private String branchState;
    private String postCode;

    public BSBDetails() {
    }

    public BSBDetails(String bsbNumber, String bankCode, String branchName, String address, String suburb, String branchState, String postCode) {
        this.bsbNumber = bsbNumber;
        this.bankCode = bankCode;
        this.branchName = branchName;
        this.address = address;
        this.suburb = suburb;
        this.branchState = branchState;
        this.postCode = postCode;
    }

    public String getBsbNumber() {
        return bsbNumber;
    }

    public void setBsbNumber(String bsbNumber) {
        this.bsbNumber = bsbNumber;
    }

    public String getBankCode() {
        return bankCode;
    }

    public void setBankCode(String bankCode) {
        this.bankCode = bankCode;
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

    public String getBranchState() {
        return branchState;
    }

    public void setBranchState(String branchState) {
        this.branchState = branchState;
    }

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }
}
