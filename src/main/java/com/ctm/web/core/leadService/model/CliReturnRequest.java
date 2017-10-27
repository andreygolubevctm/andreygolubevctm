package com.ctm.web.core.leadService.model;

public class CliReturnRequest {

    private final String phone;

    private final Integer styleCodeId;

    public String getPhone() {
        return phone;
    }

    public Integer getStyleCodeId() {
        return styleCodeId;
    }

    public CliReturnRequest(final String phone , final Integer styleCodeId) {
        this.phone = phone;
        this.styleCodeId = styleCodeId;
    }
}
