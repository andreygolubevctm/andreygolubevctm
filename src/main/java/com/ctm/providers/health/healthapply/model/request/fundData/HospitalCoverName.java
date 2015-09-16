package com.ctm.providers.health.healthapply.model.request.fundData;

import com.ctm.interfaces.common.types.ValueType;

public class HospitalCoverName extends ValueType<String> {

    private HospitalCoverName(final String value) {
        super(value);
    }

    public static HospitalCoverName instanceOf(final String value) {
        return new HospitalCoverName(value);
    }


}