package com.ctm.web.energy.apply.response;

public class EnergyApplyWebResponseModel {

    private String uniquePurchaseId;
    private Long transactionId;

    public EnergyApplyWebResponseModel(String uniquePurchaseId) {
        this.uniquePurchaseId = uniquePurchaseId;
    }

    private EnergyApplyWebResponseModel(){

    }

    public String getUniquePurchaseId() {
        return uniquePurchaseId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
