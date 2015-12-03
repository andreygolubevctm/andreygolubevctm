package com.ctm.web.health.model.results;

import com.ctm.web.core.resultsData.model.Result;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.JsonNode;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class HealthQuoteResult extends Result {

    private Promo promo;

    private Premium premium;

    private Premium altPremium;

    private JsonNode custom;

    private JsonNode extras;

    private JsonNode ambulance;

    private JsonNode hospital;

    private Long transactionId;

    private Info info;

    public Promo getPromo() {
        return promo;
    }

    public void setPromo(Promo promo) {
        this.promo = promo;
    }

    public Premium getPremium() {
        return premium;
    }

    public void setPremium(Premium premium) {
        this.premium = premium;
    }

    public Premium getAltPremium() {
        return altPremium;
    }

    public void setAltPremium(Premium altPremium) {
        this.altPremium = altPremium;
    }

    public JsonNode getCustom() {
        return custom;
    }

    public void setCustom(JsonNode custom) {
        this.custom = custom;
    }

    public JsonNode getExtras() {
        return extras;
    }

    public void setExtras(JsonNode extras) {
        this.extras = extras;
    }

    public JsonNode getAmbulance() {
        return ambulance;
    }

    public void setAmbulance(JsonNode ambulance) {
        this.ambulance = ambulance;
    }

    public JsonNode getHospital() {
        return hospital;
    }

    public void setHospital(JsonNode hospital) {
        this.hospital = hospital;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }
}
