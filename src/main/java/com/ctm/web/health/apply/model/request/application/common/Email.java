package com.ctm.web.health.apply.model.request.application.common;

import java.util.function.Supplier;

public class Email implements Supplier<String> {

    private final String email;

    public Email(final String email) {
        this.email = email;
    }

    @Override
    public String get() {
        return email;
    }
}