package com.ctm.web.health.quote.model.request;

import com.ctm.web.health.model.Frequency;

public class PriceFilter {

    private Double base;

    private Frequency frequency;

    public Double getBase() {
        return base;
    }

    public void setBase(Double base) {
        this.base = base;
    }

    public Frequency getFrequency() {
        return frequency;
    }

    public void setFrequency(Frequency frequency) {
        this.frequency = frequency;
    }
}
