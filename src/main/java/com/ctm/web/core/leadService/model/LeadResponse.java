package com.ctm.web.core.leadService.model;

public class LeadResponse {
    private String salesforceId;

    private LeadResponse() {
    }

    public String getSalesforceId() {
        return salesforceId;
    }

    @Override
    public String toString() {
        return "LeadResponse{" +
               "salesforceId=" + salesforceId +
               '}';
    }
}
