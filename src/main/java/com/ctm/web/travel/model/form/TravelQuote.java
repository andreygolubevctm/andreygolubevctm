package com.ctm.web.travel.model.form;


import com.ctm.web.core.validation.Destinations;
import com.ctm.web.core.validation.Name;

import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.Arrays;

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
    private Filter filter;
    private String unknownDestinations; // For logging destinations the user has entered which did not match any
    private String gaClientId;
    private TripType tripType;


    @Destinations
    private String destination; // comma delimited list.

    // Specific to getting a travel quote:

    private String policyType; // could be enum?
    private Dates dates;

    @Name
    private String firstName;

    @Name
    private String surname;

    @NotNull(message = "Please choose how many adults")
    private Integer adults;

    @NotNull(message = "Please choose how many children")
    private Integer children;

    private Travellers travellers;

    private ArrayList<String> destinations;


    public TravelQuote(){
        filter = new Filter();
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

    public Integer getAdults() {
        return adults;
    }

    public void setAdults(Integer adults) {
        this.adults = adults;
    }

    public Travellers getTravellers() {
        return travellers;
    }

    public void setTravellers(Travellers travellers) {
        this.travellers = travellers;
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

    public Integer getChildren() {
        return children;
    }

    public void setChildren(Integer children) {
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

    public Filter getFilter() {
        return filter;
    }

    public void setFilter(Filter filter) {
        this.filter = filter;
    }

    public String getGaclientid() {
        if (gaClientId != null && !(gaClientId.isEmpty())) {
            return gaClientId;
        } else {
            return "";
        }

    }

    public void setGaclientid(String gaClientId) { this.gaClientId = gaClientId; }

    public TripType getTripType() {
        return tripType;
    }

    public void setTripType(TripType tripType) {
        this.tripType = tripType;
    }
}
