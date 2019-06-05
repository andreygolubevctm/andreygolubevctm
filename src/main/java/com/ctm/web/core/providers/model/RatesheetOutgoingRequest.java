package com.ctm.web.core.providers.model;

import java.time.LocalDateTime;

public class RatesheetOutgoingRequest<PAYLOAD> {

    private String anonymousId;

    private String userId;

    private Long transactionId;

    private LocalDateTime requestAt;

    private String brandCode;

    private PAYLOAD payload;

    private RatesheetOutgoingRequest(Builder<PAYLOAD> builder) {
        transactionId = builder.transactionId;
        requestAt = builder.requestAt;
        brandCode = builder.brandCode;
        payload = builder.payload;
        anonymousId = builder.anonymousId;
        userId = builder.userId;
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

    public String getAnonymousId() { return anonymousId;}

    public String getUserId() { return userId;}

    public static <PAYLOAD> Builder<PAYLOAD> newBuilder() {
        return new Builder<>();
    }

    public static final class Builder<PAYLOAD> {
        private Long transactionId;
        private LocalDateTime requestAt;
        private String brandCode;
        private PAYLOAD payload;
        private String anonymousId;
        private String userId;

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

        public Builder anonymousId(String val) {
            anonymousId = val;
            return this;
        }

        public Builder userId(String val) {
            userId = val;
            return this;
        }

        public RatesheetOutgoingRequest build() {
            return new RatesheetOutgoingRequest(this);
        }
    }
}
