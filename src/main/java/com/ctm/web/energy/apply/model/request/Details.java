package com.ctm.web.energy.apply.model.request;


import com.ctm.web.core.model.Address;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.model.request.Title;

public class Details {
    private String title;
    private String firstName;
    private String lastName;
    private String dob;
    private String mobileNumberinput;
    private String otherPhoneNumberinput;
    private String email;
    private Address address;
    private Address postal;
    private YesNo postalMatch;
    private String movingDate;

    public String getTitle() {
        return title;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getDob() {
        return dob;
    }

    public String getMobileNumberinput() {
        return mobileNumberinput;
    }

    public String getOtherPhoneNumberinput() {
        return otherPhoneNumberinput;
    }

    public String getEmail() {
        return email;
    }

    public Address getAddress() {
        return address;
    }

    public Address getPostal() {
        return postal;
    }

    public YesNo getPostalMatch() {
        return postalMatch;
    }

    public String getMovingDate() {
        return movingDate;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public void setMobileNumberinput(String mobileNumberinput) {
        this.mobileNumberinput = mobileNumberinput;
    }

    public void setOtherPhoneNumberinput(String otherPhoneNumberinput) {
        this.otherPhoneNumberinput = otherPhoneNumberinput;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public void setPostal(Address postal) {
        this.postal = postal;
    }

    public void setPostalMatch(YesNo postalMatch) {
        this.postalMatch = postalMatch;
    }

    public void setMovingDate(String movingDate) {
        this.movingDate = movingDate;
    }
}
