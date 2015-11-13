package com.ctm.web.car.quote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.joda.ser.LocalDateSerializer;
import org.joda.time.LocalDate;

import java.util.ArrayList;

public class CarQuoteRequest {

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate commencementDate;

    private Integer excess;

    private Integer baseExcess;

    private Contact contact;

    private Drivers drivers;

    private RiskAddress riskAddress;

    private Vehicle vehicle;

    private ArrayList<String> providerFilter = new ArrayList<String>();

    public LocalDate getCommencementDate() {
        return commencementDate;
    }

    public void setCommencementDate(LocalDate commencementDate) {
        this.commencementDate = commencementDate;
    }

    public Integer getBaseExcess() {
        return baseExcess;
    }

    public void setBaseExcess(Integer baseExcess) {
        this.baseExcess = baseExcess;
    }

    public Integer getExcess() {
        return excess;
    }

    public void setExcess(Integer excess) {
        this.excess = excess;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public Drivers getDrivers() {
        return drivers;
    }

    public void setDrivers(Drivers drivers) {
        this.drivers = drivers;
    }

    public RiskAddress getRiskAddress() {
        return riskAddress;
    }

    public void setRiskAddress(RiskAddress riskAddress) {
        this.riskAddress = riskAddress;
    }

    public Vehicle getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle vehicle) {
        this.vehicle = vehicle;
    }

    public ArrayList<String> getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(ArrayList<String> providerFilter) {
        this.providerFilter = providerFilter;
    }
}
