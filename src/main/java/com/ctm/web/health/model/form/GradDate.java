package com.ctm.web.health.model.form;

/**
 * In the UI we reuse existing medicare card date selector component, so that we have that "cardExpiry" prefix.
 * and it is already used in several places.
 */
public class GradDate {
    private String cardExpiryMonth;
    private String cardExpiryYear;

    public String getCardExpiryMonth() {
        return cardExpiryMonth;
    }

    public void setCardExpiryMonth(String cardExpiryMonth) {
        this.cardExpiryMonth = cardExpiryMonth;
    }

    public String getCardExpiryYear() {
        return cardExpiryYear;
    }

    public void setCardExpiryYear(String cardExpiryYear) {
        this.cardExpiryYear = cardExpiryYear;
    }
}