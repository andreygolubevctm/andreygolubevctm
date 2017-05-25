package com.ctm.energy.quote.request.model;

import com.ctm.energy.quote.request.model.preferences.*;
import com.fasterxml.jackson.annotation.JsonProperty;

public class Preferences {

    private  boolean displayDiscount;
    @JsonProperty("ebilling")
    private  boolean eBilling;
    private  boolean noContract;
    private  boolean payBillsOnTime;
    private  boolean renewableEnergy;

    public Preferences(DisplayDiscount displayDiscount,
                       HasEBilling eBilling,
                       NoContract noContract,
                       HasPayBillsOnTime payBillsOnTime,
                       RenewableEnergy renewableEnergy) {
        this.displayDiscount = displayDiscount.get();
        this.eBilling = eBilling.get();
        this.noContract = noContract.get();
        this.payBillsOnTime = payBillsOnTime.get();
        this.renewableEnergy = renewableEnergy.get();
    }

    @SuppressWarnings("unused")
    private Preferences(){

    }

    public Boolean getDisplayDiscount() {
        return displayDiscount;
    }

    public Boolean getEBilling() {
        return eBilling;
    }

    public Boolean getNoContract() {
        return noContract;
    }

    public Boolean getPayBillsOnTime() {
        return payBillsOnTime;
    }

    public Boolean getRenewableEnergy() {
        return renewableEnergy;
    }
}
