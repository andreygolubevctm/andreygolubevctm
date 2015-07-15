package com.ctm.model.travel.form;

import com.ctm.web.validation.Destinations;
import com.ctm.web.validation.Name;
import com.ctm.web.validation.Numeric;

import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by twilson on 13/07/2015.
 */
public class TravelQuote {

    // Standard variables
    private String currentJourney;
    private String policyType; // could be enum?
    private String mobileUrls;
    private ArrayList<String> providerFilter;
    private Date fromDate;
    private Date toDate;

    // Validated variables
    @Name
    private String firstName;

    @Name
    private String surname;

    @NotNull(message = "Please choose how many adults")
    @Numeric
    private int numberOfAdults;

    @NotNull(message = "Please choose how many children")
    @Numeric
    private int numberOfChildren;

    @NotNull(message = "Please enter a valid number")
    @Numeric
    private int oldestPerson;

    @Destinations
    private ArrayList<String> destinations;

    public TravelQuote(){

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

    public String getCurrentJourney() {
        return currentJourney;
    }

    public void setCurrentJourney(String currentJourney) {
        this.currentJourney = currentJourney;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public int getNumberOfChildren() {
        return numberOfChildren;
    }

    public void setNumberOfChildren(int numberOfChildren) {
        this.numberOfChildren = numberOfChildren;
    }

    public ArrayList<String> getDestinations() {
        return destinations;
    }

    public void setDestinations(ArrayList<String> destinations) {
        this.destinations = destinations;
    }
}
