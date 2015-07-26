package com.ctm.providers.travel.travelquote.model.response;

import java.math.BigDecimal;

public class Benefit {

    public static final BigDecimal UNLIMITED = BigDecimal.valueOf(999999999);
    public static final BigDecimal NIL = BigDecimal.valueOf(0);
    public static final String NOT_AVAILABLE = "N/A";
    public static final String DESCRIPTION = "infoDes";
    public static final String PDS_URL = "subTitle";


    private String type; // was BenefitType

    private String code;
    private boolean override;


    private String description; // optional


    private String label; // optional


    private String text;


    private BigDecimal value;

    private boolean exempted;

    public Benefit(){

    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public boolean isOverride() {
        return override;
    }

    public void setOverride(boolean override) {
        this.override = override;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public BigDecimal getValue() {
        return value;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }

    public boolean isExempted() {
        return exempted;
    }

    public void setExempted(boolean exempted) {
        this.exempted = exempted;
    }
}
