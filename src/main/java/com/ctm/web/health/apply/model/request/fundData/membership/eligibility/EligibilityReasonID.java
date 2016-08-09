package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

import java.util.function.Supplier;

public class EligibilityReasonID implements Supplier<String> {

    private final String value;

    public EligibilityReasonID(final String value) {
        this.value = value;
    }

    @Override
    public String get() {
        return value;
    }
}
