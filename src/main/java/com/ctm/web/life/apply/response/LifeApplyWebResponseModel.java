package com.ctm.web.life.apply.response;

public class LifeApplyWebResponseModel {

    private Selection selection;
    private boolean success;
    private Long transactionId;


    private LifeApplyWebResponseModel(){

    }

    private LifeApplyWebResponseModel(Builder builder) {
        selection = builder.selection;
        success = builder.success;
        transactionId = builder.transactionId;
    }

    public Selection getSelection() {
        return selection;
    }

    public boolean isSuccess() {
        return success;
    }

    public Long getTransactionId() {
        return transactionId;
    }


    public static final class Builder {
        private Selection selection;
        private boolean success;
        private Long transactionId;

        public Builder() {
        }

        public Builder selection(Selection val) {
            selection = val;
            return this;
        }

        public Builder success(boolean val) {
            success = val;
            return this;
        }

        public Builder transactionId(Long val) {
            transactionId = val;
            return this;
        }

        public LifeApplyWebResponseModel build() {
            return new LifeApplyWebResponseModel(this);
        }
    }
}
