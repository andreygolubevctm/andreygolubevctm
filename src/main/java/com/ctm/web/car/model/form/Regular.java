package com.ctm.web.car.model.form;


import com.ctm.web.core.validation.Name;

public class Regular {

    private String claims;

    private String dob;

    private String dobInputD;

    private String dobInputM;

    private String dobInputY;

    private String employmentStatus;

    @Name
    private String firstname;

    private String gender;

    private String licenceAge;

    private String ncd;

    private String ownsAnotherCar;

    @Name
    private String surname;

    public String getClaims() {
        return claims;
    }

    public void setClaims(String claims) {
        this.claims = claims;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getDobInputD() {
        return dobInputD;
    }

    public void setDobInputD(String dobInputD) {
        this.dobInputD = dobInputD;
    }

    public String getDobInputM() {
        return dobInputM;
    }

    public void setDobInputM(String dobInputM) {
        this.dobInputM = dobInputM;
    }

    public String getDobInputY() {
        return dobInputY;
    }

    public void setDobInputY(String dobInputY) {
        this.dobInputY = dobInputY;
    }

    public String getEmploymentStatus() {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus) {
        this.employmentStatus = employmentStatus;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getLicenceAge() {
        return licenceAge;
    }

    public void setLicenceAge(String licenceAge) {
        this.licenceAge = licenceAge;
    }

    public String getNcd() {
        return ncd;
    }

    public void setNcd(String ncd) {
        this.ncd = ncd;
    }

    public String getOwnsAnotherCar() {
        return ownsAnotherCar;
    }

    public void setOwnsAnotherCar(String ownsAnotherCar) {
        this.ownsAnotherCar = ownsAnotherCar;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }
}
