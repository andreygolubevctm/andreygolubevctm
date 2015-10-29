package com.ctm.web.creditcards.model;

import com.ctm.web.validation.Name;
import com.ctm.web.validation.Numeric;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Created by voba on 26/06/2015.
 */
public class CreditCardRequest {
    @Name
    @NotEmpty(message = "Please enter your full name")
    private String name;

    @Email
    @NotEmpty(message = "Please enter your email")
    private String email;

    @Numeric(message = "Please enter a valid postcode")
    @NotEmpty(message = "Please enter the Postcode/Suburb")
    private String postcode;

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

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
}
