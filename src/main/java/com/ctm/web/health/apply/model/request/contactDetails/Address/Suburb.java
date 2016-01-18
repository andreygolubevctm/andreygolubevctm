package com.ctm.web.health.apply.model.request.contactDetails.Address;

import java.util.function.Supplier;

public class Suburb implements Supplier<String> {

    private final String suburb;

    public Suburb(final String suburb) {
        this.suburb = suburb;
    }

    @Override
    public String get() {
        return suburb;
    }
}