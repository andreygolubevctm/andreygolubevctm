package com.ctm.web.health.apply.model.request.fundData.membership;

import java.util.function.Supplier;

public class RelationshipToPrimary implements Supplier<String> {

    private final String value;

    public RelationshipToPrimary(final String value) {
        this.value = value;
    }

    @Override
    public String get() {
        return value;
    }
}