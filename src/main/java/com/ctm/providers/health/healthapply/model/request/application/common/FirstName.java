package com.ctm.providers.health.healthapply.model.request.application.common;

import java.util.function.Supplier;

public class FirstName implements Supplier<String> {

    private final String firstName;

    public FirstName(final String firstName) {
        this.firstName = firstName;
    }

    @Override
    public String get() {
        return firstName;
    }
}