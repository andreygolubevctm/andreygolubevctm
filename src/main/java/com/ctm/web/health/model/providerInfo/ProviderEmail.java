package com.ctm.web.health.model.providerInfo;

import com.ctm.interfaces.common.types.OptionalValueType;

public class ProviderEmail extends OptionalValueType<String> {

    private ProviderEmail(final String value) {
        super(value);
    }

    private ProviderEmail() {
        super();
    }

    public static ProviderEmail instanceOf(final String value) {
        return new ProviderEmail(value);
    }

    public static ProviderEmail empty() {
        return new ProviderEmail();
    }

}