package com.ctm.web.health.apply.model.request.contactDetails.Address;

import java.util.function.Supplier;

public class StreetNumber implements Supplier<String> {

    private final String streetNumber;

    public StreetNumber(final String streetNumber) {
        this.streetNumber = streetNumber;
    }

    @Override
    public String get() {
        return streetNumber;
    }
}