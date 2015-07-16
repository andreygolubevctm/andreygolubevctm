package com.ctm.providers.travel.travelquote.model.request;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by twilson on 13/07/2015.
 */
public class TravelQuoteRequest {

    private String policyType;
    private String mobileUrls;
    private int numberOfAdults;
    private int numerOfChildren;
    private int oldestPerson;
    private ArrayList<String> providerFilter;

    private ArrayList<String> detinations;
    private Date fromDate;
    private Date toDate;

    public TravelQuoteRequest(){

    }

    public String getPolicyType() {
        return policyType;
    }

    public void setPolicyType(String policyType) {
        this.policyType = policyType;
    }

    public String getMobileUrls() {
        return mobileUrls;
    }

    public void setMobileUrls(String mobileUrls) {
        this.mobileUrls = mobileUrls;
    }

    public int getNumberOfAdults() {
        return numberOfAdults;
    }

    public void setNumberOfAdults(int numberOfAdults) {
        this.numberOfAdults = numberOfAdults;
    }

    public int getNumerOfChildren() {
        return numerOfChildren;
    }

    public void setNumerOfChildren(int numerOfChildren) {
        this.numerOfChildren = numerOfChildren;
    }

    public int getOldestPerson() {
        return oldestPerson;
    }

    public void setOldestPerson(int oldestPerson) {
        this.oldestPerson = oldestPerson;
    }

    public ArrayList<String> getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(ArrayList<String> providerFilter) {
        this.providerFilter = providerFilter;
    }

    public ArrayList<String> getDetinations() {
        return detinations;
    }

    public void setDetinations(ArrayList<String> detinations) {
        this.detinations = detinations;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }
}
