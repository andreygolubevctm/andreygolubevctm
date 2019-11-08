package com.ctm.web.health.model.results;

import com.ctm.web.core.resultsData.model.Result;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.JsonNode;

import java.math.BigDecimal;
import java.util.Map;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class SelectedProduct extends Result {

    private static final long serialVersionUID = 1L;

    private Promo promo;

    private AwardScheme awardScheme;

    private Premium premium;

    private Premium altPremium;

    private Map<String, Premium> paymentTypePremiums;

    private Map<String, Premium> paymentTypeAltPremiums;

    private JsonNode custom;

    private JsonNode extras;

    private JsonNode ambulance;

    private JsonNode accident;

    private JsonNode hospital;

    private Long transactionId;

    private Info info;

    private BigDecimal giftCardAmount;

    public SelectedProduct() { }

    public SelectedProduct(HealthQuoteResult request) {
        this.setProductId(request.getProductId());
        this.promo = request.getPromo();
        this.awardScheme = request.getAwardScheme();
        this.premium = request.getPremium();
        this.altPremium = request.getAltPremium();
        this.paymentTypePremiums = request.getPaymentTypePremiums();
        this.paymentTypeAltPremiums = request.getPaymentTypeAltPremiums();
        this.custom = request.getCustom();
        this.extras = request.getExtras();
        this.ambulance = request.getAmbulance();
        this.accident = request.getAccident();
        this.hospital = request.getHospital();
        this.transactionId = request.getTransactionId();
        this.info = request.getInfo();
        this.giftCardAmount = request.getGiftCardAmount();
    }

    public Promo getPromo() {
        return promo;
    }

    public void setPromo(Promo promo) {
        this.promo = promo;
    }

    public AwardScheme getAwardScheme() {
        return awardScheme;
    }

    public void setAwardScheme(AwardScheme awardScheme) {
        this.awardScheme = awardScheme;
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

    public Map<String, Premium> getPaymentTypePremiums() {
        return paymentTypePremiums;
    }

    public void setPaymentTypePremiums(Map<String, Premium> paymentTypePremiums) {
        this.paymentTypePremiums = paymentTypePremiums;
    }

    public Map<String, Premium> getPaymentTypeAltPremiums() {
        return paymentTypeAltPremiums;
    }

    public void setPaymentTypeAltPremiums(Map<String, Premium> paymentTypeAltPremiums) {
        this.paymentTypeAltPremiums = paymentTypeAltPremiums;
    }

    public BigDecimal getGiftCardAmount() {
        return giftCardAmount;
    }

    public void setGiftCardAmount(final BigDecimal giftCardAmount) {
        this.giftCardAmount = giftCardAmount;
    }

    public JsonNode getAccident() {
        return accident;
    }

    public void setAccident(JsonNode accident) {
        this.accident = accident;
    }
}
