package com.ctm.web.simples.admin.model;

import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

public class HelpBox {

    public int helpBoxId;

    @NotEmpty(message="Help contents can not be empty")
    public String content;

    @Range(min=1, message="Operator ID must be positive Integer")
    public int operatorId;

    public String operator;

    @Range(min=0, message="StyleCode ID must be a positive Integer")
    public int styleCodeId;

    public String styleCode;

    @NotEmpty(message="Effective Start date can not be empty")
    public String effectiveStart;

    @NotEmpty(message="Effective End date  can not be empty")
    public String effectiveEnd;

    public HelpBox() {

    }

    public int getHelpBoxId() {
        return helpBoxId;
    }

    public void setHelpBoxId(int helpBoxId) {
        this.helpBoxId = helpBoxId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(int operatorId) {
        this.operatorId = operatorId;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
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
