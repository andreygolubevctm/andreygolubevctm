package com.ctm.web.simples.admin.model;

import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

public class SpecialOptIn {

    public int specialOptInId;

    @NotEmpty(message="Opt in contents can not be empty")
    public String content;

    @Range(min=0, message="Vertical ID must be a positive Integer")
    public int verticalId;

    public String vertical;

    @Range(min=0, message="StyleCode ID must be a positive Integer")
    public int styleCodeId;

    public String styleCode;

    @NotEmpty(message="Effective Start date can not be empty")
    public String effectiveStart;

    @NotEmpty(message="Effective End date  can not be empty")
    public String effectiveEnd;

    public SpecialOptIn() {

    }

    public int getSpecialOptInId() {
        return specialOptInId;
    }

    public void setSpecialOptInId(int specialOptInId) {
        this.specialOptInId = specialOptInId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getVerticalId() {
        return verticalId;
    }

    public void setVerticalId(int verticalId) {
        this.verticalId = verticalId;
    }

    public String getVertical() {
        return vertical;
    }

    public void setVertical(String vertical) {
        this.vertical = vertical;
    }

    public int getStyleCodeId() {
        return styleCodeId;
    }

    public void setStyleCodeId(int styleCodeId) {
        this.styleCodeId = styleCodeId;
    }

    public String getStyleCode() {
        return styleCode;
    }

    public void setStyleCode(String styleCode) {
        this.styleCode = styleCode;
    }

    public String getEffectiveStart() {
        return effectiveStart;
    }

    public void setEffectiveStart(String effectiveStart) {
        this.effectiveStart = effectiveStart;
    }

    public String getEffectiveEnd() {
        return effectiveEnd;
    }

    public void setEffectiveEnd(String effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }
}
