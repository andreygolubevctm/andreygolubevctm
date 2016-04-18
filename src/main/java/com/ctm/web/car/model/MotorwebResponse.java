package com.ctm.web.car.model;

public class MotorwebResponse {

    private String redbookCode;

    private String nvicode;

    private String colourCode;

    public MotorwebResponse(String redbookCode, String nvicode, String colourCode) {
        this.redbookCode = redbookCode;
        this.nvicode = nvicode;
        this.colourCode = colourCode;
    }

    public String getRedbookCode() {
        return redbookCode;
    }

    public String getNvicode() {
        return nvicode;
    }

    public String getColourCode() {
        return colourCode;
    }
}
