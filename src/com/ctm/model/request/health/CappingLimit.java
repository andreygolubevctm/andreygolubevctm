package com.ctm.model.request.health;

import com.ctm.web.validation.DateRange;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.NotNull;
import java.util.Date;


@DateRange.List({
        @DateRange(start = "effectiveStart", end = "effectiveEnd", message = "Effective Start date must be before Effective End date")
})
public class CappingLimit {

    public enum CappingLimitType {
        Monthly("MonthlyLimit") , Daily("DailyLimit");

        public final String text;
        private CappingLimitType(String text){
            this.text = text;
        }

    }

    @Range(min=1, message="Provider ID must be positive Integer")
    private int providerId;

    @NotNull(message="CappingLimitType can not be null")
    private CappingLimitType limitType;

    @Range(min=1, message="Provider ID must be positive Integer")
    private Integer cappingAmount;

    @NotNull(message="Effective Start date can not be empty")
    private Date effectiveStart;

    @NotNull(message="Effective end date can not be empty")
    private Date effectiveEnd;

    private Integer status;

    private Integer sequenceNo;

    public Integer getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(int sequenceNo) {
        this.sequenceNo = sequenceNo;
    }


    public Integer getCappingAmount() {
        return cappingAmount;
    }

    public void setCappingAmount(Integer cappingAmount) {
        this.cappingAmount = cappingAmount;
    }

    public int getProviderId() {
        return providerId;
    }

    public void setProviderId(int providerId) {
        this.providerId = providerId;
    }

    public CappingLimitType getLimitType() {
        return limitType;
    }

    public void setLimitType(String limitType) {
        if(CappingLimitType.Monthly.toString().equals(limitType)){
            this.limitType = CappingLimitType.Monthly;
        } else {
            this.limitType = CappingLimitType.Daily;
        }
    }

    public Date getEffectiveStart() {
        return this.effectiveStart;
    }

    public void setEffectiveStart(Date effectiveStart) {
        this.effectiveStart = effectiveStart;
    }

    public Date getEffectiveEnd() {
        return this.effectiveEnd;
    }

    public void setEffectiveEnd(Date effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
