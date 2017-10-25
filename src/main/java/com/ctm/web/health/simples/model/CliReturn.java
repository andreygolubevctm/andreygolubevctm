package com.ctm.web.health.simples.model;

import javax.validation.constraints.NotNull;

public class CliReturn {

    @NotNull
    private String value;


    @NotNull
    private Integer styleCodeId;

    public String getValue() {
        return value;
    }


    public void setValue(String value) {
        this.value = value;
    }

    public Integer getStyleCodeId() {
        return styleCodeId;
    }

    public void setStyleCodeId(Integer styleCodeId) {
        this.styleCodeId = styleCodeId;
    }

    @Override
    public String toString() {
        return "CliReturn{" +
                "value='" + value + '\'' +
                "styleCodeId="+styleCodeId +
                '}';
    }
}
