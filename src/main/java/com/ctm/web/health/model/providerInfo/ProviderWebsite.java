package com.ctm.web.health.model.providerInfo;

import com.ctm.interfaces.common.types.OptionalValueType;


public class ProviderWebsite extends OptionalValueType<String> {

    private ProviderWebsite(final String value) {
        super(value);
    }

    private ProviderWebsite() {
        super();
    }

    public static ProviderWebsite instanceOf(final String value) {
        return new ProviderWebsite(value);
    }

    public static ProviderWebsite empty() {
        return new ProviderWebsite();
    }

}