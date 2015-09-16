package com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund;

import com.ctm.interfaces.common.types.ValueType;

public class MemberId extends ValueType<String> {

    private MemberId(final String value) {
        super(value);
    }

    public static MemberId instanceOf(final String value) {
        return new MemberId(value);
    }

}