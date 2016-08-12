package com.ctm.web.health.apply.v2.model.request.payment.medicare;

import java.util.function.Supplier;

public class MedicareNumber implements Supplier<String> {

    private final String medicareNumber;

    public MedicareNumber(final String medicareNumber) {
        this.medicareNumber = medicareNumber;
    }

    @Override
    public String get() {
        return medicareNumber;
    }

}