package com.ctm.web.simples.admin.model.capping.product;

import org.hibernate.validator.constraints.Range;

public class GetAllRequestDTO {
    @Range(min = 1, message = "Provider ID must be positive Integer")
    private Integer providerId;

    public Integer getProviderId() {
        return providerId;
    }

    public void setProviderId(Integer providerId) {
        this.providerId = providerId;
    }
}
