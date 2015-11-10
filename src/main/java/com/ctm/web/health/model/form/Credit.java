package com.ctm.web.health.model.form;

public class Credit {

    public static final Credit NONE = new Credit("", "", "", Expiry.NONE, "", null);

    private String type;

    private String name;

    private String number;

    private Expiry expiry;

    private String ccv;

    private Integer day;

    public Credit(String type, String name, String number, Expiry expiry, String ccv, Integer day) {
        this.type = type;
        this.name = name;
        this.number = number;
        this.expiry = expiry;
        this.ccv = ccv;
        this.day = day;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Expiry getExpiry() {
        return expiry;
    }

    public void setExpiry(Expiry expiry) {
        this.expiry = expiry;
    }

    public String getCcv() {
        return ccv;
    }

    public void setCcv(String ccv) {
        this.ccv = ccv;
    }

    public Integer getDay() {
        return day;
    }

    public void setDay(Integer day) {
        this.day = day;
    }
}
