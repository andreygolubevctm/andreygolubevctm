package com.ctm.web.health.model.leadservice;

import javax.validation.constraints.NotNull;

public class DelayLead {

    @NotNull
    private String phone;

    @NotNull
    private Integer styleCodeId;

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

    @Override
    public String toString() {
        return "DelayLead{" +
                "phone='" + phone + '\'' +
                "styleCodeId="+styleCodeId +
                '}';
    }
}
