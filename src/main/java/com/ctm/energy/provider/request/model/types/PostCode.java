package com.ctm.energy.provider.request.model.types;

import com.ctm.interfaces.common.types.ValueType;

public final class PostCode extends ValueType<String> {

    private PostCode(final String value) {
        super(value);
    }

    public static PostCode instanceOf(final String value) {
        return new PostCode(value);
    }

}