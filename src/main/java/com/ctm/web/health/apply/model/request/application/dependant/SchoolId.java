package com.ctm.web.health.apply.model.request.application.dependant;


import java.util.function.Supplier;

public class SchoolId implements Supplier<String> {

    private final String schoolID;

    public SchoolId(final String schoolID) {
        this.schoolID = schoolID;
    }

    @Override
    public String get() {
        return schoolID;
    }
}