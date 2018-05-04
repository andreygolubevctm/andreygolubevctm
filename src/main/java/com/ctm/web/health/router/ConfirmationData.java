package com.ctm.web.health.router;

import com.ctm.web.health.model.providerInfo.ProviderInfo;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlCData;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

import java.time.LocalDate;

@JacksonXmlRootElement(localName = "data")
public class ConfirmationData {

    private final String transID;

    private final String status = "OK";

    private final String vertical = "CTMH";

    @JsonSerialize(using = AUSLocalDateSerializer.class)
    private final LocalDate startDate;

    private final String frequency;

    @JacksonXmlCData
    private final String about;

    private final String firstName;
    private final String lastName;

    private final ProviderInfo providerInfo;

    @JacksonXmlCData
    private final String whatsNext;

    @JacksonXmlCData
    private final String product;

    private final String policyNo;

    private final String paymentType;

    private final String redemptionId;

    private final String voucherValue;

    private ConfirmationData(Builder builder) {
        this.transID = builder.transID;
        this.startDate = builder.startDate;
        this.frequency = builder.frequency;
        this.about = builder.about;
        this.firstName = builder.firstName;
        this.lastName = builder.lastName;
        this.providerInfo = builder.providerInfo;
        this.whatsNext = builder.whatsNext;
        this.product = builder.product;
        this.policyNo = builder.policyNo;
        this.paymentType = builder.paymentType;
        this.redemptionId = builder.redemptionId;
        this.voucherValue = builder.voucherValue;
    }

    public static Builder newConfirmationData() {
        return new Builder();
    }

    public String getTransID() {
        return transID;
    }

    public String getStatus() {
        return status;
    }

    public String getVertical() {
        return vertical;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public String getFrequency() {
        return frequency;
    }

    public String getAbout() {
        return about;
    }

    public String getWhatsNext() {
        return whatsNext;
    }

    public String getProduct() {
        return product;
    }

    public String getPolicyNo() {
        return policyNo;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public ProviderInfo getProviderInfo() {
        return providerInfo;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public String getRedemptionId() {
        return redemptionId;
    }

    public String getVoucherValue() {
        return voucherValue;
    }

    public static final class Builder {
        private String transID;
        private LocalDate startDate;
        private String frequency;
        private String about;
        private String firstName;
        private String lastName;
        private ProviderInfo providerInfo;
        private String whatsNext;
        private String product;
        private String policyNo;
        private String paymentType;
        private String redemptionId;
        private String voucherValue;

        private Builder() {
        }

        public ConfirmationData build() {
            return new ConfirmationData(this);
        }

        public Builder transID(String transID) {
            this.transID = transID;
            return this;
        }

        public Builder startDate(LocalDate startDate) {
            this.startDate = startDate;
            return this;
        }

        public Builder frequency(String frequency) {
            this.frequency = frequency;
            return this;
        }

        public Builder about(String about) {
            this.about = about;
            return this;
        }

        public Builder firstName(String firstName) {
            this.firstName = firstName;
            return this;
        }

        public Builder lastName(String lastName) {
            this.lastName = lastName;
            return this;
        }

        public Builder providerInfo(ProviderInfo providerInfo) {
            this.providerInfo = providerInfo;
            return this;
        }

        public Builder whatsNext(String whatsNext) {
            this.whatsNext = whatsNext;
            return this;
        }

        public Builder product(String product) {
            this.product = product;
            return this;
        }

        public Builder policyNo(String policyNo) {
            this.policyNo = policyNo;
            return this;
        }

        public Builder paymentType(String paymentType) {
            this.paymentType = paymentType;
            return this;
        }

        public Builder redemptionId(String redemptionId) {
            this.redemptionId = redemptionId;
            return this;
        }

        public Builder voucherValue(String voucherValue) {
            this.voucherValue = voucherValue;
            return this;
        }
    }
}