package com.ctm.web.energy.apply.model.request;


import com.ctm.web.core.model.Address;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.model.request.Title;

public class Details {
    private Title title;
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

    private Details(){

    }

    public Title getTitle() {
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
}
