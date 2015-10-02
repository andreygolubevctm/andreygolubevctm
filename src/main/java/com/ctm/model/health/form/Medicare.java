package com.ctm.model.health.form;

public class Medicare {

    private String cover;

    private String number;

    private Expiry expiry;

    private String firstName;

    private String middleInitial;

    private String surname;

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Expiry getExpiry() {
        return expiry;
    }

    public void setExpiry(Expiry expiry) {
        this.expiry = expiry;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleInitial() {
        return middleInitial;
    }

    public void setMiddleInitial(String middleInitial) {
        this.middleInitial = middleInitial;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }
}
