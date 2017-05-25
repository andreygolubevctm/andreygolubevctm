package com.ctm.energy.quote.response.model;


import com.ctm.energy.quote.response.model.discount.*;

public class Discount {

    private  String payOnTime;
    private  String eBilling;
    private  String guaranteed;
    private  String other;
    private  String details;

    public Discount(PayBillsOnTimeDiscount payOnTime, EBillingDiscount eBilling, GuaranteedDiscount guaranteed, OtherDiscount other, DiscountDetails details) {
        this.payOnTime = payOnTime.get();
        this.eBilling = eBilling.get();
        this.guaranteed = guaranteed.get();
        this.other = other.get();
        this.details = details.get();
    }

    @SuppressWarnings("unused")
    private Discount(){

    }

    public String getPayOnTime() {
        return payOnTime;
    }

    public String getGuaranteed() {
        return guaranteed;
    }


    public String getOther() {
        return other;
    }

    public String getDetails() {
        return details;
    }

    public String geteBilling() {
        return eBilling;
    }
}
