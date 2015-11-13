package com.ctm.web.travel.model.results;

import java.math.BigDecimal;

/**
 * Part of the Java model which will build the travel result sent to the front end.
 */
public class Benefit {

    private String type;
    private String label;
    private String text;
    private String desc;
    private String order;
    private BigDecimal value;

    public Benefit(){

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

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public BigDecimal getValue() {
        return value;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }
}
