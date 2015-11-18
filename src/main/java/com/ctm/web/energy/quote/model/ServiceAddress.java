package com.ctm.web.energy.quote.model;

import java.util.Date;

/**
 * Created by lbuchanan on 18/11/2015.
 */
public class ServiceAddress {

    private String suburb;
    private String postCode;
    private boolean movingIn;
    private Date movingInDate;
    private boolean hasSolarPanels;
    private String tariff;

    public String getSuburb() {
        return suburb;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    public boolean isMovingIn() {
        return movingIn;
    }

    public void setMovingIn(boolean movingIn) {
        this.movingIn = movingIn;
    }

    public Date getMovingInDate() {
        return movingInDate;
    }

    public void setMovingInDate(Date movingInDate) {
        this.movingInDate = movingInDate;
    }

    public boolean isHasSolarPanels() {
        return hasSolarPanels;
    }

    public void setHasSolarPanels(boolean hasSolarPanels) {
        this.hasSolarPanels = hasSolarPanels;
    }

    public String getTariff() {
        return tariff;
    }

    public void setTariff(String tariff) {
        this.tariff = tariff;
    }
}
