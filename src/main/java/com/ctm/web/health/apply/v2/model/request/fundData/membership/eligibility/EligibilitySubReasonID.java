package com.ctm.web.health.apply.v2.model.request.fundData.membership.eligibility;

import java.util.function.Supplier;

public class EligibilitySubReasonID implements Supplier<String> {

    private final String value;

    public EligibilitySubReasonID(final String value) {
        this.value = value;
    }

    @Override
    public String get() {
        return value;
    }
}
