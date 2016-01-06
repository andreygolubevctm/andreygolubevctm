package com.ctm.web.car.model.form;

public class Vehicle {

    private String accessories;

    private String accessoriesRadioBtns;

    private String annualKilometres;

    private String body;

    private String damage;

    private String factoryOptions;

    private String factoryOptionsRadioBtns;

    private String finance;

    private String fuel;

    private String make;

    private String makeDes;

    private String marketValue;

    private String model;

    private String modelDes;

    private String modifications;

    private String parking;

    private String redbookCode;

    private String registrationYear;

    private String securityOption;

    private String securityOptionCheck;

    private String trans;

    private String use;

    private String variant;

    private String year;

    public String getAccessories() {
        return accessories;
    }

    public void setAccessories(String accessories) {
        this.accessories = accessories;
    }

    public String getAccessoriesRadioBtns() {
        return accessoriesRadioBtns;
    }

    public void setAccessoriesRadioBtns(String accessoriesRadioBtns) {
        this.accessoriesRadioBtns = accessoriesRadioBtns;
    }

    public String getAnnualKilometres() {
        return annualKilometres;
    }

    public void setAnnualKilometres(String annualKilometres) {
        this.annualKilometres = annualKilometres.replaceAll("[^\\d.]","");
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getDamage() {
        return damage;
    }

    public void setDamage(String damage) {
        this.damage = damage;
    }

    public String getFactoryOptions() {
        return factoryOptions;
    }

    public void setFactoryOptions(String factoryOptions) {
        this.factoryOptions = factoryOptions;
    }

    public String getFactoryOptionsRadioBtns() {
        return factoryOptionsRadioBtns;
    }

    public void setFactoryOptionsRadioBtns(String factoryOptionsRadioBtns) {
        this.factoryOptionsRadioBtns = factoryOptionsRadioBtns;
    }

    public String getFinance() {
        return finance;
    }

    public void setFinance(String finance) {
        this.finance = finance;
    }

    public String getFuel() {
        return fuel;
    }

    public void setFuel(String fuel) {
        this.fuel = fuel;
    }

    public String getMake() {
        return make;
    }

    public void setMake(String make) {
        this.make = make;
    }

    public String getMakeDes() {
        return makeDes;
    }

    public void setMakeDes(String makeDes) {
        this.makeDes = makeDes;
    }

    public String getMarketValue() {
        return marketValue;
    }

    public void setMarketValue(String marketValue) {
        this.marketValue = marketValue;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getModelDes() {
        return modelDes;
    }

    public void setModelDes(String modelDes) {
        this.modelDes = modelDes;
    }

    public String getModifications() {
        return modifications;
    }

    public void setModifications(String modifications) {
        this.modifications = modifications;
    }

    public String getParking() {
        return parking;
    }

    public void setParking(String parking) {
        this.parking = parking;
    }

    public String getRedbookCode() {
        return redbookCode;
    }

    public void setRedbookCode(String redbookCode) {
        this.redbookCode = redbookCode;
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

    public String getSecurityOptionCheck() {
        return securityOptionCheck;
    }

    public void setSecurityOptionCheck(String securityOptionCheck) {
        this.securityOptionCheck = securityOptionCheck;
    }

    public String getTrans() {
        return trans;
    }

    public void setTrans(String trans) {
        this.trans = trans;
    }

    public String getUse() {
        return use;
    }

    public void setUse(String use) {
        this.use = use;
    }

    public String getVariant() {
        return variant;
    }

    public void setVariant(String variant) {
        this.variant = variant;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }
}
