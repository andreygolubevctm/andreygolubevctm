package com.ctm.web.health.apply.model.request.contactDetails.Address;

import java.util.function.Supplier;

public class FullAddressOneLine implements Supplier<String> {

    private final String fullAddressOneLine;

    public FullAddressOneLine(final String fullAddressOneLine) {
        this.fullAddressOneLine = fullAddressOneLine;
    }

    @Override
    public String get() {
        return fullAddressOneLine;
    }
}