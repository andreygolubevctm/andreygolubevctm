package com.ctm.web.health.apply.model.request.payment.medicare;

import java.util.function.Supplier;

public class Position implements Supplier<Integer> {

    private final int position;

    public Position(final int position) {
        this.position = position;
    }

    @Override
    public Integer get() {
        return position;
    }
}