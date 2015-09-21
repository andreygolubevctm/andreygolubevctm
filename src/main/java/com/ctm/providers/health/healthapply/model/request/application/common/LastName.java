package com.ctm.providers.health.healthapply.model.request.application.common;

import java.util.function.Supplier;

public class LastName implements Supplier<String> {

    private final String lastName;

    public LastName(final String lastName) {
        this.lastName = lastName;
    }

    @Override
    public String get() {
        return lastName;
    }
}