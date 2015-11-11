package com.ctm.web.health.model.form;

public class Expiry {

<<<<<<< HEAD
=======
    public static final Expiry NONE = new Expiry("", "");

>>>>>>> origin/feature/HLT-2479
    private String cardExpiryMonth;

    private String cardExpiryYear;

<<<<<<< HEAD
=======
    public Expiry(String cardExpiryMonth, String cardExpiryYear) {
        this.cardExpiryMonth = cardExpiryMonth;
        this.cardExpiryYear = cardExpiryYear;
    }

>>>>>>> origin/feature/HLT-2479
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
