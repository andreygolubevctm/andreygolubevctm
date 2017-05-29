package com.ctm.energy.quote.request.model;


public class ContactDetails {

    private boolean optedInPhone;

    private Title title;
    private String firstName;
    private String phone;

    public ContactDetails(boolean optedInPhone, Title title, String firstName, String phone) {
        this.optedInPhone = optedInPhone;
        this.title = title;
        this.firstName = firstName;
        this.phone = phone;
    }

    @SuppressWarnings("unused")
    private ContactDetails(){

    }

    public boolean isOptedInPhone() {
        return optedInPhone;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getPhone() {
        return phone;
    }

    public Title getTitle() {
        return title;
    }
}
