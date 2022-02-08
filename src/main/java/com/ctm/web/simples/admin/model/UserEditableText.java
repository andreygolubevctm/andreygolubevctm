package com.ctm.web.simples.admin.model;

import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

public class UserEditableText {

    private int textId;

    private String textType;

    @NotEmpty(message="Help contents can not be empty")
    private String content;

    @Range(min=1, message="Operator ID must be positive Integer")
    private int operatorId;

    private String operator;

    @Range(min=0, message="StyleCode ID must be a positive Integer")
    private int styleCodeId;

    private String styleCode;

    @NotEmpty(message="Effective Start date can not be empty")
    private String effectiveStart;

    @NotEmpty(message="Effective End date  can not be empty")
    private String effectiveEnd;

    public String getContent() {
        return content;
    }

    public String getEffectiveStart() {
        return effectiveStart;
    }

    public String getEffectiveEnd() {
        return effectiveEnd;
    }

    public int getOperatorId() {
        return operatorId;
    }

    public String getOperator() {
        return operator;
    }

    public int getStyleCodeId() {
        return styleCodeId;
    }

    public String getStyleCode() {
        return styleCode;
    }

    public int getTextId() {
        return textId;
    }

    public String getTextType() {
        return textType;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setEffectiveStart(String effectiveStart) {
        this.effectiveStart = effectiveStart;
    }

    public void setEffectiveEnd(String effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }

    public void setOperatorId(int operatorId) {
        this.operatorId = operatorId;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public void setStyleCodeId(int styleCodeId) {
        this.styleCodeId = styleCodeId;
    }

    public void setStyleCode(String styleCode) {
        this.styleCode = styleCode;
    }

    public void setTextId(int textId) {
        this.textId = textId;
    }

    public void setTextType(String textType) {
        this.textType = textType;
    }

}
