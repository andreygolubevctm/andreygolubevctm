package com.ctm.web.car.quote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CarQuoteRequest {

    private String clientIp;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate commencementDate;

    private Integer excess;

    private Integer baseExcess;

    private Contact contact;

    private Drivers drivers;

    private RiskAddress riskAddress;

    private Vehicle vehicle;

    private TypeOfCover typeOfCover;

    private String quoteReferenceNumber;

    private List<String> providerFilter = new ArrayList<String>();

    public String getClientIp() {
        return clientIp;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

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

    public List<String> getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(List<String> providerFilter) {
        this.providerFilter = providerFilter;
    }

    public TypeOfCover getTypeOfCover() {
        return typeOfCover;
    }

    public void setTypeOfCover(TypeOfCover typeOfCover) {
        this.typeOfCover = typeOfCover;
    }

    public String getQuoteReferenceNumber() {
        return quoteReferenceNumber;
    }

    public void setQuoteReferenceNumber(String quoteReferenceNumber) {
        this.quoteReferenceNumber = quoteReferenceNumber;
    }
}
