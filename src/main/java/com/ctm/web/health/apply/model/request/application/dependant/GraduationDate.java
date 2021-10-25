package com.ctm.web.health.apply.model.request.application.dependant;

import java.util.function.Supplier;

public class GraduationDate implements Supplier<String> {

    private final String graduationDate;

    public GraduationDate(String graduationDate) {
        this.graduationDate = graduationDate;
    }

    @Override
    public String get() {
        return graduationDate;
    }
}