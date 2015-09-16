package com.ctm.providers.health.healthapply.model.request.contactDetails;

import com.ctm.interfaces.common.types.ValueType;

import javax.validation.constraints.NotNull;

public class OtherNumber extends ValueType<String> {

    public static final OtherNumber NONE = new OtherNumber("");

    @NotNull
    private OtherNumber(final String value) {
        super(value);
    }

    public static OtherNumber instanceOf(final String value) {
        if(value != null) {
            final String validNumber = value.replaceAll(" ", "").replaceAll("\\(", "").replaceAll("\\)", "");
            if(validNumber.matches("0\\d{9}")) {
                return new OtherNumber(validNumber);
            }
        }
        throw new IllegalArgumentException("Invalid moble phone number: " + value);
    }

}