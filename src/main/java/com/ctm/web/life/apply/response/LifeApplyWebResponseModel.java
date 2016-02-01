package com.ctm.web.life.apply.response;

public class LifeApplyWebResponseModel {

    private String uniquePurchaseId;
    private Long transactionId;
    private String confirmationkey;
    private boolean success;

    private LifeApplyWebResponseModel(){

    }

    private LifeApplyWebResponseModel(EnergyApplyWebResponseModelBuilder builder) {
        uniquePurchaseId = builder.uniquePurchaseId;
        transactionId =builder.transactionId;
        confirmationkey = builder.confirmationkey;
    }

    public String getUniquePurchaseId() {
        return uniquePurchaseId;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public String getConfirmationkey() {
        return confirmationkey;
    }

    public static final class EnergyApplyWebResponseModelBuilder {
        private String uniquePurchaseId;
        private Long transactionId;
        private String confirmationkey;

        public EnergyApplyWebResponseModelBuilder() {
        }

        public EnergyApplyWebResponseModelBuilder uniquePurchaseId(String val) {
            uniquePurchaseId = val;
            return this;
        }

        public EnergyApplyWebResponseModelBuilder transactionId(Long val) {
            transactionId = val;
            return this;
        }

        public EnergyApplyWebResponseModelBuilder confirmationkey(String val) {
            confirmationkey = val;
            return this;
        }

        public LifeApplyWebResponseModel build() {
            return new LifeApplyWebResponseModel(this);
        }
    }
}
