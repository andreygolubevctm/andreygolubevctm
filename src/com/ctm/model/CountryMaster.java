package com.ctm.model;

/**
 * Created by bthompson on 24/03/2015.
 */
public class CountryMaster {

    private String isoCode = "";
    private String countryName = "";

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getIsoCode() {
        return isoCode;
    }

    public void setIsoCode(String isoCode) {
        this.isoCode = isoCode;
    }


}
