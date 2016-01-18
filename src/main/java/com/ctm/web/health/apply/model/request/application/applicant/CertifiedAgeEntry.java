package com.ctm.web.health.apply.model.request.application.applicant;

import java.util.function.Supplier;

public class CertifiedAgeEntry implements Supplier<Integer> {

    private final Integer value;

    public CertifiedAgeEntry(final Integer value) {
        this.value = value;
    }

    @Override
    public Integer get() {
        return value;
    }
}
