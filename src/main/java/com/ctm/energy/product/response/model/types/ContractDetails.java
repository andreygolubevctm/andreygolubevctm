package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class ContractDetails extends OptionalValueType<String> {

    private ContractDetails(final String value) {
        super(value);
    }

    private ContractDetails() {
        super();
    }

    public static ContractDetails instanceOf(final String value) {
        return new ContractDetails(value);
    }

    public static ContractDetails empty() {
        return new ContractDetails();
    }

}