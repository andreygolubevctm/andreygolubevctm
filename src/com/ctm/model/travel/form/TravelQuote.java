package com.ctm.model.travel.form;

import com.ctm.web.validation.Destinations;
import com.ctm.web.validation.Name;
import com.ctm.web.validation.Numeric;

import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

/**
 * Map web_ctm front end travel quote to Java object (with validation)
 */
public class TravelQuote {

    // Hidden page variables.

    private String renderingMode; // The user's responsive breakpoint
    private String privacyoptin;
    private String marketing;
    private String lastFieldTouch;
    private String email;
    private String currentJourney; // if A/B test parameter is present
    private ArrayList<String> providerFilter; // NXI only: allow user to select to view single provider only.
    private String unknownDestinations; // For logging destinations the user has entered which did not match any
    private String destination; // comma delimited list.

    // Specific to getting a travel quote:

    private String policyType; // could be enum?
    private Dates dates;

    @Name
    private String firstName;

    @Name
    private String surname;

    @NotNull(message = "Please choose how many adults")
    @Numeric
    private int adults;

    @NotNull(message = "Please choose how many children")
    @Numeric
    private int children;

    @NotNull(message = "Please enter a valid number")
    @Numeric
    private int oldest;

    @Destinations
    private ArrayList<String> destinations;




    public TravelQuote(){

    }


    public Dates getDates() {
        return dates;
    }

    public void setDates(Dates dates) {
        this.dates = dates;
    }

    public String getPolicyType() {
        return policyType;
    }

    public void setPolicyType(String policyType) {
        this.policyType = policyType;
    }

    public int getAdults() {
        return adults;
    }

    public void setAdults(int adults) {
        this.adults = adults;
    }

    public int getOldest() {
        return oldest;
    }

    public void setOldest(int oldest) {
        this.oldest = oldest;
    }

    public ArrayList<String> getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(ArrayList<String> providerFilter) {
        this.providerFilter = providerFilter;
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

    public int getChildren() {
        return children;
    }

    public void setChildren(int children) {
        this.children = children;
    }

    public ArrayList<String> getDestinations() {
        return destinations;
    }


    public void setDestinations(ArrayList<String> destinations) {
        this.destinations = destinations;
    }

    public String getDestination(){
        return destination;
    }

    public void setDestination(String destination){
        this.destination = destination;

        destinations = new ArrayList<String>();
        String[] splitString = destination.split(",");
        destinations.addAll(Arrays.asList(splitString));
    }

    public String getRenderingMode() {
        return renderingMode;
    }

    public void setRenderingMode(String renderingMode) {
        this.renderingMode = renderingMode;
    }

    public String getPrivacyoptin() {
        return privacyoptin;
    }

    public void setPrivacyoptin(String privacyoptin) {
        this.privacyoptin = privacyoptin;
    }

    public String getMarketing() {
        return marketing;
    }

    public void setMarketing(String marketing) {
        this.marketing = marketing;
    }

    public String getLastFieldTouch() {
        return lastFieldTouch;
    }

    public void setLastFieldTouch(String lastFieldTouch) {
        this.lastFieldTouch = lastFieldTouch;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUnknownDestinations() {
        return unknownDestinations;
    }

    public void setUnknownDestinations(String unknownDestinations) {
        this.unknownDestinations = unknownDestinations;
    }
}
