package com.ctm.web.energy.apply.model.request;


public class Partner {
    private String uniqueCustomerId;

    public Partner(String uniqueCustomerId){
        this.uniqueCustomerId = uniqueCustomerId;
    }

    private Partner(){

    }

    public String getUniqueCustomerId() {
        return uniqueCustomerId;
    }
}
