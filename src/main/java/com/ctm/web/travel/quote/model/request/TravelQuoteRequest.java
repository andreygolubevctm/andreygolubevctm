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

    private String clientIp;
    private PolicyType policyType;

    private String firstName;
    private String lastName;

    private List<Traveller> travellers;

    @Deprecated
    private boolean mobileUrls = false;

    @Deprecated
    private int numberOfAdults;

    @Deprecated
    private int numberOfChildren;

    @Deprecated
    @JsonSerialize(contentUsing = LocalDateSerializer.class)
    private List<LocalDate> travellersDOB;

    @JsonSerialize
    private List<Integer> travellersAge;

    private ArrayList<String> providerFilter = new ArrayList<String>();
    private SingleTripDetails singleTripDetails;
    private TripType tripType;


    public TravelQuoteRequest(){
    }

    public String getClientIp() {
        return clientIp;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

    public PolicyType getPolicyType() {
        return policyType;
    }

    public void setPolicyType(PolicyType policyType) {
        this.policyType = policyType;
    }

    public List<Traveller> getTravellers() {
        return travellers;
    }

    public void setTravellers(List<Traveller> travellers) {
        this.travellers = travellers;
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

    public List<Integer> getTravellersAge() {
        return travellersAge;
    }

    public void setTravellersAge(List<Integer> travellersAge) {
        this.travellersAge = travellersAge;
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

    public TripType getTripType() {
        return tripType;
    }

    public void setTripType(TripType tripType) {
        this.tripType = tripType;
    }
}
