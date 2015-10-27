package com.ctm.model.health.form;

public class Gateway {

    private String registered;

    private String number;

    private String type;

    private String expiry;

    private String name;

    private Nab nab;

    public String getRegistered() {
        return registered;
    }

    public void setRegistered(String registered) {
        this.registered = registered;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getExpiry() {
        return expiry;
    }

    public void setExpiry(String expiry) {
        this.expiry = expiry;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Nab getNab() {
        return nab;
    }

    public void setNab(Nab nab) {
        this.nab = nab;
    }
}
