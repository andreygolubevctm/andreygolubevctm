package com.ctm.web.car.model.request.propensityscore;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ClassProbability implements Serializable {

    @JsonProperty(value = "0.0")
    private Double zero;

    @JsonProperty(value = "1.0")
    private Double one;

    public Double getZero() {
        return zero;
    }

    public void setZero(Double zero) {
        this.zero = zero;
    }

    public Double getOne() {
        return one;
    }

    public void setOne(Double one) {
        this.one = one;
    }
}
