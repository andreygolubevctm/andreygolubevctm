package com.ctm.web.core.providers.model;

import java.time.LocalDateTime;

public class GenericOutgoingRequest<PAYLOAD> {

    private Long transactionId;

    private LocalDateTime requestAt;

    private String brandCode;

    private PAYLOAD payload;

    private GenericOutgoingRequest(Builder<PAYLOAD> builder) {
        transactionId = builder.transactionId;
        requestAt = builder.requestAt;
        brandCode = builder.brandCode;
        payload = builder.payload;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public LocalDateTime getRequestAt() {
        return requestAt;
    }

    public String getBrandCode() {
        return brandCode;
    }

    public PAYLOAD getPayload() {
        return payload;
    }

    public static <PAYLOAD> Builder<PAYLOAD> newBuilder() {
        return new Builder<>();
    }

    public static final class Builder<PAYLOAD> {
        private Long transactionId;
        private LocalDateTime requestAt;
        private String brandCode;
        private PAYLOAD payload;

        private Builder() {
        }

        public Builder transactionId(Long val) {
            transactionId = val;
            return this;
        }

        public Builder requestAt(LocalDateTime val) {
            requestAt = val;
            return this;
        }

        public Builder brandCode(String val) {
            brandCode = val;
            return this;
        }

        public Builder payload(PAYLOAD val) {
            payload = val;
            return this;
        }

        public GenericOutgoingRequest<PAYLOAD> build() {
            return new GenericOutgoingRequest<>(this);
        }
    }
}
