package com.ctm.web.health.simples.model;

import javax.validation.constraints.NotNull;

public class CliReturn {

    @NotNull
    private String value;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return "CliReturn{" +
                "value='" + value + '\'' +
                '}';
    }
}
