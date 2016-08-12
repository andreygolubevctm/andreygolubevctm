package com.ctm.web.health.apply.v2.model.request.payment.bank.account;

import java.util.function.Supplier;

public class BSB implements Supplier<String> {

    private final String bsb;

    public BSB(final String bsb) {
        this.bsb = bsb;
    }

    @Override
    public String get() {
        return bsb;
    }
}