package com.ctm.model.travel.results;

/**
 * Part of the Java model which will build the travel result sent to the front end.
 */
public class Benefit {

    private String label;
    private String text;
    private String desc;
    private String order;

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
}
