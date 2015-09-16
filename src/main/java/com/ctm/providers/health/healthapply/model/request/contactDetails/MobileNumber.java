package com.ctm.providers.health.healthapply.model.request.contactDetails;

import com.ctm.interfaces.common.types.ValueType;

public class MobileNumber extends ValueType<String> {

    public static final MobileNumber NONE = new MobileNumber("");

    private MobileNumber(final String value) {
        super(value);
    }

    public static MobileNumber instanceOf(final String value) {
        if(value != null) {
            final String validNumber = value.replaceAll(" ", "").replaceAll("\\(", "").replaceAll("\\)", "");
            if(validNumber.matches("0[4,5]\\d{8}")) {
                return new MobileNumber(validNumber);
            }
        }
        throw new IllegalArgumentException("Invalid moble phone number: " + value);
    }

}