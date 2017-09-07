package com.ctm.apply.model.request;

import com.ctm.interfaces.common.types.*;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;

import javax.validation.Valid;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.List;

public class ApplyRequest<PAYLOAD>  {
    @NotNull
    @Size(min = 1)
    private final String brandCode;

    @Min(1)
    public final long transactionId;

    @NotNull
    private final String clientIp;

    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    private final LocalDateTime requestAt;

    private String productId;

    private List<String> providerCodes;

    @NotNull
    @Valid
    private PAYLOAD payload;

    // empty constructor needed by jackson
    @SuppressWarnings("UnusedDeclaration")
    protected ApplyRequest() {
        this.brandCode = "";
        this.transactionId = 0;
        this.clientIp = "";
        requestAt = null;
    }

    private ApplyRequest(Builder<PAYLOAD> builder) {
        brandCode = builder.brandCode;
        transactionId = builder.transactionId;
        clientIp = builder.clientIp;
        requestAt = builder.requestAt;
        productId = builder.productId;
        providerCodes = builder.providerCodes;
        payload = builder.payload;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        ApplyRequest that = (ApplyRequest) o;

        if (transactionId != that.transactionId) return false;
        if (brandCode != null ? !brandCode.equals(that.brandCode) : that.brandCode != null) return false;
        if (clientIp != null ? !clientIp.equals(that.clientIp) : that.clientIp != null) return false;
        return !(requestAt != null ? !requestAt.equals(that.requestAt) : that.requestAt != null);

    }

    @Override
    public int hashCode() {
        int result = brandCode != null ? brandCode.hashCode() : 0;
        result = 31 * result + (int) (transactionId ^ (transactionId >>> 32));
        result = 31 * result + (clientIp != null ? clientIp.hashCode() : 0);
        result = 31 * result + (requestAt != null ? requestAt.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "ApplicationRequest{" +
                "brandCode='" + brandCode + '\'' +
                ", transactionId=" + transactionId +
                ", clientIp='" + clientIp + '\'' +
                ", requestAt=" + requestAt +
                '}';
    }

    @JsonSerialize(using = ValueSerializer.class)
    public BrandCode getBrandCode() {
        return BrandCode.instanceOf(brandCode);
    }

    @JsonSerialize(using = ValueSerializer.class)
    public TransactionId getTransactionId() {
        return TransactionId.instanceOf(transactionId);
    }

    @JsonSerialize(using = ValueSerializer.class)
    public ClientIP getClientIp() {
        return ClientIP.instanceOf(clientIp);
    }

    @JsonSerialize(using = ValueSerializer.class)
    public RequestAt getRequestAt() {
        return RequestAt.instanceOf(requestAt);
    }


    @JsonSerialize(using = ValueSerializer.class)
    public ProductId getProductId() {
        return ProductId.instanceOf(productId);
    }

    public List<String> getProviderCodes() {
        return providerCodes;
    }

    public PAYLOAD getPayload() {
        return payload;
    }


    public static final class Builder<PAYLOAD> {
        private  String brandCode;
        private  long transactionId;
        private  String clientIp;
        private  LocalDateTime requestAt;
        private String productId;
        private List<String> providerCodes;
        private PAYLOAD payload;


        public Builder productId(String val) {
            productId = val;
            return this;
        }

        public Builder providerCodes(List<String> val) {
            providerCodes = val;
            return this;
        }

        public Builder payload(PAYLOAD val) {
            payload = val;
            return this;
        }

        public ApplyRequest build() {
            return new ApplyRequest(this);
        }

        public Builder brandCode(String brandCode) {
            this.brandCode = brandCode;
            return this;
        }

        public Builder transactionId(long transactionId) {
            this.transactionId = transactionId;
            return this;
        }

        public Builder clientIp(String clientIp) {
            this.clientIp = clientIp;
            return this;
        }

        public Builder requestAt(LocalDateTime requestAt) {
            this.requestAt = requestAt;
            return this;
        }
    }
}
