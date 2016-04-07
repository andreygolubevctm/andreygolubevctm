package com.ctm.web.travel.quote.model.request;


import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;
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
    private String firstName;
    private String lastName;

    @JsonSerialize(contentUsing = LocalDateSerializer.class)
    private List<LocalDate> travellersDOB;
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

    public List<LocalDate> getTravellersDOB() {
        return travellersDOB;
    }

    public void setTravellersDOB(List<LocalDate> travellersDOBs) {
        this.travellersDOB = travellersDOBs;
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

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
