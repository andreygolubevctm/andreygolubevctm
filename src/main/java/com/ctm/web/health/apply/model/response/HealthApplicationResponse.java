package com.ctm.web.health.apply.model.response;

import java.util.List;

import static java.util.Collections.emptyList;

public class HealthApplicationResponse {

    public String fundId;

    public String productId;

    public Status success;

    public List<PartnerError> errorList;

    public String bccEmail;

    public String getFundId() {
        return fundId;
    }

    public String getProductId() {
        return productId;
    }

    public Status getSuccess() {
        return success;
    }

    public List<PartnerError> getErrorList() {
        return errorList == null ? emptyList() : errorList;
    }

    public String getBccEmail() {
        return bccEmail;
    }

    public void setFundId(String fundId) {
        this.fundId = fundId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public void setSuccess(Status success) {
        this.success = success;
    }

    public void setErrorList(List<PartnerError> errorList) {
        this.errorList = errorList;
    }

    public void setBccEmail(String bccEmail) {
        this.bccEmail = bccEmail;
    }
}
