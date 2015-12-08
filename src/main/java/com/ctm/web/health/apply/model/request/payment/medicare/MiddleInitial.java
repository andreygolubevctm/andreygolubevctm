package com.ctm.web.health.apply.model.request.payment.medicare;

import java.util.function.Supplier;

/**
 * Created by voba on 30/09/2015.
 */
public class MiddleInitial implements Supplier<String> {

    private final String middleInitial;

    public MiddleInitial(final String middleInitial) {
        this.middleInitial = middleInitial;
    }

    @Override
    public String get() {
        return middleInitial;
    }
}
