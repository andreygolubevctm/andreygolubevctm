package com.ctm.providers.car.carquote.model.request;

public class Drivers {

    private RegularDriver regularDriver;

    private YoungestDriver youngestDriver;

    private String driversRestriction;

    public RegularDriver getRegularDriver() {
        return regularDriver;
    }

    public void setRegularDriver(RegularDriver regularDriver) {
        this.regularDriver = regularDriver;
    }

    public YoungestDriver getYoungestDriver() {
        return youngestDriver;
    }

    public void setYoungestDriver(YoungestDriver youngestDriver) {
        this.youngestDriver = youngestDriver;
    }

    public String getDriversRestriction() {
        return driversRestriction;
    }

    public void setDriversRestriction(String driversRestriction) {
        this.driversRestriction = driversRestriction;
    }
}
