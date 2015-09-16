package com.ctm.providers.health.healthapply.model.request.contactDetails;


import com.ctm.interfaces.common.types.ValueType;

public class Email extends ValueType<String> {

    public static final Email NONE = new Email("");

    private Email(final String value) {
        super(value);
    }

    @org.hibernate.validator.constraints.Email
    public static Email instanceOf(final String value) {
        return new Email(value);
    }

}