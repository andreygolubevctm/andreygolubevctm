package com.ctm.web.life.model.request;

import com.ctm.web.core.model.formData.YesNo;
import org.hibernate.validator.constraints.Email;

public class ContactDetails {

    private String contactNumber;
    private YesNo call;
    @Email
    private String email;

    public String getContactNumber() {
        return contactNumber;
    }

    public YesNo getCall() {
        return call;
    }

    public String getEmail() {
        return email;
    }
}
