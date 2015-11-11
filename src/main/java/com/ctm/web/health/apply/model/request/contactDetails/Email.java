package com.ctm.web.health.apply.model.request.contactDetails;

import java.util.function.Supplier;

public class Email implements Supplier<String> {

    private final String email;

    public Email(String email) {
        this.email = email;
    }

    @Override
    public String get() {
        return email;
    }
}