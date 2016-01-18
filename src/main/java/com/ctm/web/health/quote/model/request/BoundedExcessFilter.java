package com.ctm.web.health.quote.model.request;

public class BoundedExcessFilter implements ExcessFilter {

    private Integer excessMax;

    private Integer excessMin;

    public Integer getExcessMax() {
        return excessMax;
    }

    public void setExcessMax(Integer excessMax) {
        this.excessMax = excessMax;
    }

    public Integer getExcessMin() {
        return excessMin;
    }

    public void setExcessMin(Integer excessMin) {
        this.excessMin = excessMin;
    }
}
