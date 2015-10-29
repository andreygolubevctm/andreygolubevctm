package com.ctm.web.health.model.request;

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
    public enum CappingLimitCategory {
        Hard("H") , Soft("S");

        public final String text;
        CappingLimitCategory(String text){
            this.text = text;
        }

    }
    @Range(min=1, message="Provider ID must be positive Integer")
    private int providerId;

    @NotNull(message="CappingLimitType can not be empty and must be either 'Daily' or 'Monthly'")
    private CappingLimitType limitType;

    private Integer cappingAmount;

    @NotNull(message="Effective Start date can not be empty")
    private Date effectiveStart;

    @NotNull(message="Effective end date can not be empty")
    private Date effectiveEnd;

    @NotNull(message="Capping limit Category can not be empty and must be either Hard 'H' or Soft 'S'")
    private CappingLimitCategory cappingLimitCategory;

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
        } else if(CappingLimitType.Daily.toString().equals(limitType)){
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

    public String getCappingLimitCategory() {
        return cappingLimitCategory.text;
    }

    public void setCappingLimitCategory(String limitCategory) {
        if(CappingLimitCategory.Hard.text.equals(limitCategory)){
            this.cappingLimitCategory = CappingLimitCategory.Hard;
        } else if(CappingLimitCategory.Soft.text.equals(limitCategory)){
            this.cappingLimitCategory = CappingLimitCategory.Soft;
        }
    }

}
