package com.ctm.web.health.apply.model.request.fundData;

import java.util.function.Supplier;

public class Provider implements Supplier<String> {

    private final String provider;

    public Provider(final String provider) {
        this.provider = provider;
    }

    @Override
    public String get() {
        return provider;
    }
}