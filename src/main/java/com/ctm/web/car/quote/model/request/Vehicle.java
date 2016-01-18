package com.ctm.web.car.quote.model.request;

import java.util.List;

import static java.util.Collections.emptyList;

public class Vehicle {

    private String make;

    private String model;

    private Integer year;

    private String body;

    private String transmission;

    private String fuelType;

    private String redbookCode;

    private List<NonStandardAccessory> nonStandardAccessories = emptyList();

    private Integer annualKilometres;

    private boolean hasDamage;

    private List<String> factoryOptions = emptyList();

    private String financeType;

    private String marketValue;

    private boolean hasModifications;

    private String registrationYear;

    private String securityOption;

    private String use;

    private String passengerPayment;

    private String goodsPayment;

    public String getMake() {
        return make;
    }

    public void setMake(String make) {
        this.make = make;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getTransmission() {
        return transmission;
    }

    public void setTransmission(String transmission) {
        this.transmission = transmission;
    }

    public String getFuelType() {
        return fuelType;
    }

    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }

    public String getRedbookCode() {
        return redbookCode;
    }

    public void setRedbookCode(String redbookCode) {
        this.redbookCode = redbookCode;
    }

    public List<NonStandardAccessory> getNonStandardAccessories() {
        return nonStandardAccessories;
    }

    public void setNonStandardAccessories(List<NonStandardAccessory> nonStandardAccessories) {
        this.nonStandardAccessories = nonStandardAccessories;
    }

    public Integer getAnnualKilometres() {
        return annualKilometres;
    }

    public void setAnnualKilometres(Integer annualKilometres) {
        this.annualKilometres = annualKilometres;
    }

    public boolean isHasDamage() {
        return hasDamage;
    }

    public void setHasDamage(boolean hasDamage) {
        this.hasDamage = hasDamage;
    }

    public List<String> getFactoryOptions() {
        return factoryOptions;
    }

    public void setFactoryOptions(List<String> factoryOptions) {
        this.factoryOptions = factoryOptions;
    }

    public String getFinanceType() {
        return financeType;
    }

    public void setFinanceType(String financeType) {
        this.financeType = financeType;
    }

    public String getMarketValue() {
        return marketValue;
    }

    public void setMarketValue(String marketValue) {
        this.marketValue = marketValue;
    }

    public boolean isHasModifications() {
        return hasModifications;
    }

    public void setHasModifications(boolean hasModifications) {
        this.hasModifications = hasModifications;
    }

    public String getRegistrationYear() {
        return registrationYear;
    }

    public void setRegistrationYear(String registrationYear) {
        this.registrationYear = registrationYear;
    }

    public String getSecurityOption() {
        return securityOption;
    }

    public void setSecurityOption(String securityOption) {
        this.securityOption = securityOption;
    }

    public String getUse() {
        return use;
    }

    public void setUse(String use) {
        this.use = use;
    }

    public void setPassengerPayment(String passengerPayment) {
        this.passengerPayment = passengerPayment;
    }

    public String getPassengerPayment() {
        return passengerPayment;
    }

    public void setGoodsPayment(String goodsPayment) {
        this.goodsPayment = goodsPayment;
    }

    public String getGoodsPayment() {
        return goodsPayment;
    }
}
