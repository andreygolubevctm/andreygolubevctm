package com.ctm.web.health.model.form;

public class Expiry {

    public static final Expiry NONE = new Expiry("", "");

    private String cardExpiryMonth;

    private String cardExpiryYear;

    public Expiry(String cardExpiryMonth, String cardExpiryYear) {
        this.cardExpiryMonth = cardExpiryMonth;
        this.cardExpiryYear = cardExpiryYear;
    }

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
