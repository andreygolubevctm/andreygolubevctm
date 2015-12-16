package com.ctm.web.energy.apply.response;

public class EnergyApplyWebResponseModel {

    private String uniquePurchaseId;
    private Long transactionId;
    private String confirmationkey;

    private EnergyApplyWebResponseModel(){

    }

    private EnergyApplyWebResponseModel(EnergyApplyWebResponseModelBuilder builder) {
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

        public EnergyApplyWebResponseModel build() {
            return new EnergyApplyWebResponseModel(this);
        }
    }
}
