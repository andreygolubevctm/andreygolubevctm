package com.ctm.model.request;

import com.ctm.model.request.health.CappingLimit;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.NotNull;


public class CappingLimitDeleteRequest {

    @Range(min=1, message="Provider ID must be positive Integer")
    private int providerId;
    @NotNull(message="CappingLimitType can not be null")
    private CappingLimit.CappingLimitType limitType;
    @NotNull
    private Integer sequenceNo;

    public int getProviderId() {
        return providerId;
    }

    public void setProviderId(int providerId) {
        this.providerId = providerId;
    }

    public Integer getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(Integer sequenceNo) {
        this.sequenceNo = sequenceNo;
    }

    public void setLimitType(String limitType) {
        if(CappingLimit.CappingLimitType.Monthly.toString().equals(limitType)){
            this.limitType = CappingLimit.CappingLimitType.Monthly;
        } else {
            this.limitType = CappingLimit.CappingLimitType.Daily;
        }
    }

    public CappingLimit.CappingLimitType getLimitType() {
        return limitType;
    }
}
