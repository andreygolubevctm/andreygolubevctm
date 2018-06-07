package com.ctm.web.health.simples.model;

import javax.validation.constraints.NotNull;

public class DelayLead {

    @NotNull
    private String phone;

    @NotNull
    private Integer styleCodeId;

    @NotNull
    private String source;

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getStyleCodeId() {
        return styleCodeId;
    }

    public void setStyleCodeId(Integer styleCodeId) {
        this.styleCodeId = styleCodeId;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    @Override
    public String toString() {
        return "DelayLead{" +
                "source='" + source + "'" +
                "phone='" + phone + "'" +
                "styleCodeId="+styleCodeId +
                '}';
    }
}
