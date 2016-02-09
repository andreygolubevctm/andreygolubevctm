package com.ctm.web.health.apply.model.request.application.dependant;

import java.util.function.Supplier;

public class School implements Supplier<String> {

    private final String school;

    public School(String school) {
        this.school = school;
    }

    @Override
    public String get() {
        return school;
    }
}