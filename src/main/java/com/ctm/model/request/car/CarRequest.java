package com.ctm.model.request.car;

import javax.validation.Valid;

/**
 * Created by voba on 6/07/2015.
 */
public class CarRequest {
    @Valid
    private Driver drivers;

    public Driver getDrivers() {
        return drivers;
    }

    public void setDrivers(Driver drivers) {
        this.drivers = drivers;
    }
}
