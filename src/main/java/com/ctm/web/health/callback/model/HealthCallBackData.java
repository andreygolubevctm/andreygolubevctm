package com.ctm.web.health.callback.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.ScriptAssert;

import javax.validation.constraints.NotNull;

@ScriptAssert(lang = "javascript", script = "_this.mustHaveContactNumber()", message = "Must have at least a contact number")
public class HealthCallBackData {

    @NotNull
    private Long transactionId;

    private String scheduledDateTime;

    private String mobileNumber;

    private String otherNumber;

    @NotNull
    private String name;

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getScheduledDateTime() {
        return scheduledDateTime;
    }

    public void setScheduledDateTime(String scheduledDateTime) {
        this.scheduledDateTime = scheduledDateTime;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getOtherNumber() {
        return otherNumber;
    }

    public void setOtherNumber(String otherNumber) {
        this.otherNumber = otherNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @JsonIgnore
    public boolean mustHaveContactNumber() {
        return StringUtils.isNotBlank(mobileNumber) || StringUtils.isNotBlank(otherNumber);
    }

}
