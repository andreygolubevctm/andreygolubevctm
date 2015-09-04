package com.ctm.providers.health.healthquote.model.response;

import com.fasterxml.jackson.databind.JsonNode;

public class HealthQuote {

    public boolean available = true;

    public String service;

    public String productId;

    private Info info;

    private Premium premium;

    private Premium alternativePremium;

    private JsonNode custom;
    private JsonNode hospital;
    private JsonNode extras;
    private JsonNode ambulance;

    private Promo promo;

    private boolean priceChanged;

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }

    public Premium getPremium() {
        return premium;
    }

    public void setPremium(Premium premium) {
        this.premium = premium;
    }

    public Premium getAlternativePremium() {
        return alternativePremium;
    }

    public void setAlternativePremium(Premium alternativePremium) {
        this.alternativePremium = alternativePremium;
    }

    public JsonNode getCustom() {
        return custom;
    }

    public void setCustom(JsonNode custom) {
        this.custom = custom;
    }

    public JsonNode getHospital() {
        return hospital;
    }

    public void setHospital(JsonNode hospital) {
        this.hospital = hospital;
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

    public Promo getPromo() {
        return promo;
    }

    public void setPromo(Promo promo) {
        this.promo = promo;
    }

    public boolean isPriceChanged() {
        return priceChanged;
    }

    public void setPriceChanged(boolean priceChanged) {
        this.priceChanged = priceChanged;
    }
}
