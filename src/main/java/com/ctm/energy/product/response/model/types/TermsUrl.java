package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class TermsUrl extends OptionalValueType<String> {

    private TermsUrl(final String value) {
        super(value);
    }

    private TermsUrl() {
        super();
    }

    public static TermsUrl instanceOf(final String value) {
        return new TermsUrl(value);
    }

    public static TermsUrl empty() {
        return new TermsUrl();
    }

}