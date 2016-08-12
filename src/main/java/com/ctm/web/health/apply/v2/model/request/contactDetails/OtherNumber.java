package com.ctm.web.health.apply.v2.model.request.contactDetails;

import java.util.function.Supplier;

public class OtherNumber implements Supplier<String> {

    public OtherNumber(final String otherNumber) {
        this.otherNumber = otherNumber;
    }

    private final String otherNumber;

    @Override
    public String get() {
        return otherNumber;
    }
}