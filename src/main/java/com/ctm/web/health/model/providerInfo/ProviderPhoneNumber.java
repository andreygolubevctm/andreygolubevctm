package com.ctm.web.health.model.providerInfo;

import com.ctm.interfaces.common.types.OptionalValueType;

public class ProviderPhoneNumber extends OptionalValueType<String> {

    private ProviderPhoneNumber(final String value) {
        super(value);
    }

    private ProviderPhoneNumber() {
        super();
    }

    public static ProviderPhoneNumber instanceOf(final String value) {
        return new ProviderPhoneNumber(value);
    }

    public static ProviderPhoneNumber empty() {
        return new ProviderPhoneNumber();
    }

}