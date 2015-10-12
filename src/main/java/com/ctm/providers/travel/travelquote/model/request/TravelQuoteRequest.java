package com.ctm.providers.travel.travelquote.model.request;

import org.joda.time.LocalDate;

import java.util.ArrayList;
import java.util.List;

/**
 * The request model for calling CtM's travel-quote application.
 *
 * Future note: This should be automatically generated from a travel-quote API.
 *
 */
public class TravelQuoteRequest {

    private PolicyType policyType;
    private boolean mobileUrls = false;
    private int numberOfAdults;
    private int numberOfChildren;
    private List<String> travellersDOB =  new ArrayList<String>();
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

    public boolean getMobileUrls() {
        return mobileUrls;
    }

    public void setMobileUrls(boolean mobileUrls) {
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

    public void setNumberOfChildren(int numberOfChildren) {
        this.numberOfChildren = numberOfChildren;
    }

    public List<String> getTravellersDOB() {
        return travellersDOB;
    }

    public void setTravellersDOB(List<LocalDate> travellersDOBs) {
        travellersDOB.clear();

        travellersDOBs.stream().forEach(age -> {
            this.travellersDOB.add(age.toString());
        });
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
