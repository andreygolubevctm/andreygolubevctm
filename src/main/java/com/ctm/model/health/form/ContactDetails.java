package com.ctm.model.health.form;

public class ContactDetails {

    private String name;

    private String email;

    private ContactNumber contactNumber;

    private String flexiContactNumberinput;

    private String optInEmail;

    private String call;

    private String optin;

    private Competition competition;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public ContactNumber getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(ContactNumber contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getFlexiContactNumberinput() {
        return flexiContactNumberinput;
    }

    public void setFlexiContactNumberinput(String flexiContactNumberinput) {
        this.flexiContactNumberinput = flexiContactNumberinput;
    }

    public String getOptInEmail() {
        return optInEmail;
    }

    public void setOptInEmail(String optInEmail) {
        this.optInEmail = optInEmail;
    }

    public String getCall() {
        return call;
    }

    public void setCall(String call) {
        this.call = call;
    }

    public String getOptin() {
        return optin;
    }

    public void setOptin(String optin) {
        this.optin = optin;
    }

    public Competition getCompetition() {
        return competition;
    }

    public void setCompetition(Competition competition) {
        this.competition = competition;
    }
}
