package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class PrivacyPolicyUrl extends OptionalValueType<String> {

    private PrivacyPolicyUrl(final String value) {
        super(value);
    }

    private PrivacyPolicyUrl() {
        super();
    }

    public static PrivacyPolicyUrl instanceOf(final String value) {
        return new PrivacyPolicyUrl(value);
    }

    public static PrivacyPolicyUrl empty() {
        return new PrivacyPolicyUrl();
    }

}