package com.ctm.model.request.car;

import com.ctm.model.request.Person;

import javax.validation.Valid;

/**
 * Created by voba on 6/07/2015.
 */
public class Driver {
    @Valid
    private Person regular;

    public Person getRegular() {
        return regular;
    }

    public void setRegular(Person regular) {
        this.regular = regular;
    }
}
