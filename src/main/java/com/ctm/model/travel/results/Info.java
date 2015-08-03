package com.ctm.model.travel.results;

import java.math.BigDecimal;

/**
 * Java model which will build the travel result sent to the front end.
 * This model is used to hold the data and sort values for the results page.
 * This model is converted to JSON.
 */
public class Info {

    private String excess;
    private BigDecimal excessValue;
    private String medical;
    private BigDecimal medicalValue;
    private String cxdfee;
    private BigDecimal cxdfeeValue;
    private String luggage;
    private BigDecimal luggageValue;

    public Info(){

    }

    public String getExcess() {
        return excess;
    }

    public void setExcess(String excess) {
        this.excess = excess;
    }

    public String getMedical() {
        return medical;
    }

    public void setMedical(String medical) {
        this.medical = medical;
    }

    public String getCxdfee() {
        return cxdfee;
    }

    public void setCxdfee(String cxdfee) {
        this.cxdfee = cxdfee;
    }

    public String getLuggage() {
        return luggage;
    }

    public void setLuggage(String luggage) {
        this.luggage = luggage;
    }

    public BigDecimal getExcessValue() {
        return excessValue;
    }

    public void setExcessValue(BigDecimal excessValue) {
        this.excessValue = excessValue;
    }

    public BigDecimal getMedicalValue() {
        return medicalValue;
    }

    public void setMedicalValue(BigDecimal medicalValue) {
        this.medicalValue = medicalValue;
    }

    public BigDecimal getCxdfeeValue() {
        return cxdfeeValue;
    }

    public void setCxdfeeValue(BigDecimal cxdfeeValue) {
        this.cxdfeeValue = cxdfeeValue;
    }

    public BigDecimal getLuggageValue() {
        return luggageValue;
    }

    public void setLuggageValue(BigDecimal luggageValue) {
        this.luggageValue = luggageValue;
    }
}
