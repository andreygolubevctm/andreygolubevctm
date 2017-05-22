package com.ctm.energy.provider.response.model.types;

import com.ctm.interfaces.common.types.ValueType;

public class ElectricityTariff extends ValueType<String> {

    private ElectricityTariff(final String value) {
        super(value);
    }

    public static ElectricityTariff instanceOf(final String value) {
        return new ElectricityTariff(value);
    }

}