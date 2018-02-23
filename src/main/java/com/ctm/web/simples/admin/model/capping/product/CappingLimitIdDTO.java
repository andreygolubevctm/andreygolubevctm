package com.ctm.web.simples.admin.model.capping.product;

import org.hibernate.validator.constraints.Range;

public class CappingLimitIdDTO {
    @Range(min = 1, message = "Capping Limit ID must be positive Integer")
    private Integer cappingLimitId;

    public Integer getCappingLimitId() {
        return cappingLimitId;
    }

    public void setCappingLimitId(Integer cappingLimitId) {
        this.cappingLimitId = cappingLimitId;
    }
}
