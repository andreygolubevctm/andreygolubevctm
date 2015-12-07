package com.ctm.web.health.apply.model.request.contactDetails.Address;

import java.util.function.Supplier;

public class Postcode implements Supplier<String> {

    private final String postCode;

    public Postcode(final String postCode) {
        this.postCode = postCode;
    }

    @Override
    public String get() {
        return postCode;
    }
}