package com.ctm.life.quote.model.response;

import com.ctm.interfaces.common.aggregator.response.Quote;
import com.ctm.interfaces.common.types.PartnerError;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;
import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@SuppressWarnings("UnusedDeclaration")
@JsonInclude(NON_EMPTY)
public class LifeQuote implements Quote {

    @JacksonXmlProperty(isAttribute = true)
    private boolean available = true;

    @NotNull
    private ServiceId service;

    @NotNull
    private Product product;


    @NotNull
    @Size(min = 1)
    @JacksonXmlProperty(isAttribute = true)
    private String productId;

    private String reference;

    @NotNull
    public ApplicantType applicantType;

    // empty constructor needed by jackson
    @SuppressWarnings("UnusedDeclaration")
    private LifeQuote() {
    }

    private LifeQuote(Builder builder) {
        available = builder.available;
        service = builder.service;
        product = builder.product;
        productId = builder.productId;
        reference = builder.reference;
        applicantType = builder.applicantType;
    }

    public static LifeQuote unavailable(final ProductId productId, final ServiceId serviceId) {
        Builder builder = new Builder();
        return builder.productId(productId.get()).service(serviceId).build();
    }

    @Override
    @JsonSerialize(using = ValueSerializer.class)
    public ServiceId getService() {
        return service;
    }

    @Override
    @JsonSerialize(using = ValueSerializer.class)
    public ProductId getProductId() {
        return ProductId.instanceOf(productId);
    }

    @Override
    public List<PartnerError> getErrorList() {
        return null;
    }

    public boolean isAvailable() {
        return available;
    }

    public Product getProduct() {
        return product;
    }

    public ApplicantType getApplicantType() {
        return applicantType;
    }

    public Optional<String> getReference() {
        return Optional.ofNullable(reference);
    }

    public static final class Builder {
        private boolean available;
        private ServiceId service;
        private Product product;
        private String productId;
        private String reference;
        private ApplicantType applicantType;

        public Builder available(boolean val) {
            available = val;
            return this;
        }

        public Builder service(ServiceId val) {
            service = val;
            return this;
        }

        public Builder product(Product val) {
            product = val;
            return this;
        }

        public Builder productId(String val) {
            productId = val;
            return this;
        }

        public Builder reference(String val) {
            reference = val;
            return this;
        }

        public Builder applicantType(ApplicantType val) {
            applicantType = val;
            return this;
        }

        public LifeQuote build() {
            return new LifeQuote(this);
        }
    }
}
