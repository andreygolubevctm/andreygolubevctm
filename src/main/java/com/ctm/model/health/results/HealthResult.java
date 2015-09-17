package com.ctm.model.health.results;

import java.util.List;

public class HealthResult {

    private String fund;

    private boolean success;

    private String policyNo;

    private String bccEmail;

    private List<Error> errors;

    private List<Error> allowedErrors;

    public String getFund() {
        return fund;
    }

    public void setFund(String fund) {
        this.fund = fund;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getPolicyNo() {
        return policyNo;
    }

    public void setPolicyNo(String policyNo) {
        this.policyNo = policyNo;
    }

    public List<Error> getErrors() {
        return errors;
    }

    public void setErrors(List<Error> errors) {
        this.errors = errors;
    }

    public List<Error> getAllowedErrors() {
        return allowedErrors;
    }

    public void setAllowedErrors(List<Error> allowedErrors) {
        this.allowedErrors = allowedErrors;
    }

    public String getBccEmail() {
        return bccEmail;
    }

    public void setBccEmail(String bccEmail) {
        this.bccEmail = bccEmail;
    }
}
