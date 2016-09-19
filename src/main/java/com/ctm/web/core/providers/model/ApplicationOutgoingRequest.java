package com.ctm.web.core.providers.model;

import java.time.LocalDateTime;

public class ApplicationOutgoingRequest<PAYLOAD> {

    private Long transactionId;

    private LocalDateTime requestAt;

    private String brandCode;

    private String providerFilter;

    private PAYLOAD payload;

    private ApplicationOutgoingRequest(Builder<PAYLOAD> builder) {
        transactionId = builder.transactionId;
        requestAt = builder.requestAt;
        brandCode = builder.brandCode;
        providerFilter = builder.providerFilter;
        payload = builder.payload;
    }

    public static <PAYLOAD> Builder<PAYLOAD> newBuilder() {
        return new Builder<>();
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

    public String getProviderFilter() {
        return providerFilter;
    }

    public PAYLOAD getPayload() {
        return payload;
    }


    public static final class Builder<PAYLOAD> {
        private Long transactionId;
        private LocalDateTime requestAt;
        private String brandCode;
        private String providerFilter;
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

        public Builder providerFilter(String val) {
            providerFilter = val;
            return this;
        }

        public Builder payload(PAYLOAD val) {
            payload = val;
            return this;
        }

        public ApplicationOutgoingRequest build() {
            return new ApplicationOutgoingRequest(this);
        }
    }
}
