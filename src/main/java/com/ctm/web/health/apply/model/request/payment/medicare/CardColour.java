package com.ctm.web.health.apply.model.request.payment.medicare;

import java.util.function.Supplier;

public class CardColour implements Supplier<String> {

    private final String colour;

    public CardColour(String colour) { this.colour = colour; }

    @Override
    public String get() {
        return colour;
    }
}
