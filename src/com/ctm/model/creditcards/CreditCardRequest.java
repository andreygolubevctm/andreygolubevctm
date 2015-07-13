package com.ctm.model.creditcards;

import com.ctm.web.validation.Name;
import com.ctm.web.validation.Numeric;
import org.hibernate.validator.constraints.Email;

/**
 * Created by voba on 26/06/2015.
 */
public class CreditCardRequest {
    @Name
    private String name;

    @Email
    private String email;

    @Numeric(message = "Please enter a valid postcode")
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
