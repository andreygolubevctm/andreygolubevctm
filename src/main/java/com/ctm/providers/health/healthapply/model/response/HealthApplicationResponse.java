package com.ctm.providers.health.healthapply.model.response;

import java.util.List;

public class HealthApplicationResponse {

    public String fundId;

    public String productId;

    public Status success;

    public List<PartnerError> errorList;


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
        return errorList;
    }
}
