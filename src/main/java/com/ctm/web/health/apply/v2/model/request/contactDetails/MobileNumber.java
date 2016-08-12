package com.ctm.web.health.apply.v2.model.request.contactDetails;

import java.util.function.Supplier;

public class MobileNumber implements Supplier<String> {

    private final String mobileNumber;

    public MobileNumber(final String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    @Override
    public String get() {
        return mobileNumber;
    }
}