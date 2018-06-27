package com.ctm.web.health.simples.model;

public class DelayLeadRequest {

    private final String source;

    private final String phone;

    private final Integer styleCodeId;

    public String getSource() {
        return source;
    }

    public String getPhone() {
        return phone;
    }

    public Integer getStyleCodeId() {
        return styleCodeId;
    }

    public DelayLeadRequest(final String phone, final Integer styleCodeId, final String source) {
        this.phone = phone;
        this.styleCodeId = styleCodeId;
        this.source = source;
    }
}
