package com.ctm.web.health.quote.model.response;

import com.ctm.web.health.model.PaymentType;
import com.fasterxml.jackson.databind.JsonNode;

import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

public class HealthQuote {

    public boolean available = true;

    public String service;

    public String productId;

    public String productUpi;

    private UUID journeyId;

    private UUID quoteId;

    private Info info;

    private Premium premium;

    private Premium alternativePremium;

    private Map<PaymentType, Premium> paymentTypePremiums;

    private Map<PaymentType, Premium> paymentTypeAltPremiums;

    private JsonNode custom;
    private JsonNode hospital;
    private JsonNode extras;
    private JsonNode ambulance;
    private JsonNode accident;

    private Promotion promotion;

    private boolean priceChanged;

    private LocalDate dropDeadDate;

    private LocalDate pricingDate;

    private GiftCard giftCard;

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

    public String getProductUpi() {
        return productUpi;
    }

    public void setProductUpi(String productUpi) {
        this.productUpi = productUpi;
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

    public Promotion getPromotion() {
        return promotion;
    }

    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
    }

    public boolean isPriceChanged() {
        return priceChanged;
    }

    public void setPriceChanged(boolean priceChanged) {
        this.priceChanged = priceChanged;
    }

    public Map<PaymentType, Premium> getPaymentTypePremiums() {
        return paymentTypePremiums;
    }

    public void setPaymentTypePremiums(Map<PaymentType, Premium> paymentTypePremiums) {
        this.paymentTypePremiums = paymentTypePremiums;
    }

    public Map<PaymentType, Premium> getPaymentTypeAltPremiums() {
        return paymentTypeAltPremiums;
    }

    public void setPaymentTypeAltPremiums(Map<PaymentType, Premium> paymentTypeAltPremiums) {
        this.paymentTypeAltPremiums = paymentTypeAltPremiums;
    }

    public LocalDate getDropDeadDate() {
        return dropDeadDate;
    }

    public void setDropDeadDate(final LocalDate dropDeadDate) {
        this.dropDeadDate = dropDeadDate;
    }

    public LocalDate getPricingDate() {
        return pricingDate;
    }

    public void setPricingDate(final LocalDate pricingDate) {
        this.pricingDate = pricingDate;
    }

    public Optional<GiftCard> getGiftCard() {
        return Optional.ofNullable(giftCard);
    }

    public void setGiftCard(final GiftCard giftCard) {
        this.giftCard = giftCard;
    }

    public JsonNode getAccident() {
        return accident;
    }

    public void setAccident(JsonNode accident) {
        this.accident = accident;
    }

    public UUID getJourneyId() {
        return journeyId;
    }

    public void setJourneyId(UUID journeyId) {
        this.journeyId = journeyId;
    }

    public UUID getQuoteId() {
        return quoteId;
    }

    public void setQuoteId(UUID quoteId) {
        this.quoteId = quoteId;
    }
}
