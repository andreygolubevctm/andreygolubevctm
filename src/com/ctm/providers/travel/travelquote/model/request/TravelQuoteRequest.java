package com.ctm.providers.travel.travelquote.model.request;

import java.util.ArrayList;

/**
 * Created by twilson on 13/07/2015.
 */
public class TravelQuoteRequest {

    private PolicyType policyType;
    private String mobileUrls;
    private int numberOfAdults;
    private int numberOfChildren;
    private int oldestPerson;
    private ArrayList<String> providerFilter = new ArrayList<String>();

    private SingleTripDetails singleTripDetails;


    public TravelQuoteRequest(){
    }

    public PolicyType getPolicyType() {
        return policyType;
    }

    public void setPolicyType(PolicyType policyType) {
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

    public int getNumberOfChildren() {
        return numberOfChildren;
    }

    public void setNumberOfChildren(int nubmerOfChildren) {
        this.numberOfChildren = numberOfChildren;
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

    public SingleTripDetails getSingleTripDetails() {
        return singleTripDetails;
    }

    public void setSingleTripDetails(SingleTripDetails singleTripDetails) {
        this.singleTripDetails = singleTripDetails;
    }
}
