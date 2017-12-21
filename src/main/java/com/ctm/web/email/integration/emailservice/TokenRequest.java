package com.ctm.web.email.integration.emailservice;


import com.ctm.interfaces.common.types.VerticalType;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import org.apache.commons.lang3.math.NumberUtils;

import java.util.Optional;

@ApiModel
@JsonIgnoreProperties(ignoreUnknown = true)
public class TokenRequest {
    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonDeserialize
    private Long transactionId;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private String hashedEmail;

    @ApiModelProperty(dataType = "java.lang.Integer")
    @JsonDeserialize
    private Integer styleCodeId;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private EmailTokenType emailTokenType;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private EmailTokenAction action;

    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonDeserialize
    private Long emailId;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private String productId;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private String campaignId;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private VerticalType vertical;

    @ApiModelProperty(dataType = "java.lang.String", notes = "It needs to be URL encoded")
    @JsonDeserialize
    private String productName;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private String travelPolicyType;

    @ApiModelProperty(dataType = "java.lang.String", notes = "It needs to be URL encoded")
    @JsonDeserialize
    private String emailAddress;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonDeserialize
    private String source;

    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonDeserialize
    private Long accountId;

    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonDeserialize
    private Long journeyId;

    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonDeserialize
    private Long orderLineId;

    /* Jackson Deserialization */
    private TokenRequest() {}

    private TokenRequest(Builder builder) {
        transactionId = builder.transactionId;
        hashedEmail = builder.hashedEmail;
        styleCodeId = builder.styleCodeId;
        emailTokenType = builder.emailTokenType;
        action = builder.action;
        emailId = builder.emailId;
        productId = builder.productId;
        campaignId = builder.campaignId;
        vertical = builder.vertical;
        productName = builder.productName;
        travelPolicyType = builder.travelPolicyType;
        emailAddress = builder.emailAddress;
        source = builder.source;
        accountId = builder.accountId;
        journeyId = builder.journeyId;
        orderLineId = builder.orderLineId;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public static Builder newBuilder(TokenRequest copy) {
        return new Builder(copy);
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public String getHashedEmail() {
        return hashedEmail;
    }

    public Integer getStyleCodeId() {
        return styleCodeId;
    }

    public EmailTokenType getEmailTokenType() {
        return emailTokenType;
    }

    public EmailTokenAction getAction() {
        return action;
    }

    public Long getEmailId() {
        return emailId;
    }

    public String getProductId() {
        return productId;
    }

    public String getCampaignId() {
        return campaignId;
    }

    public VerticalType getVertical() {
        return vertical;
    }

    public String getProductName() {
        return productName;
    }

    public String getTravelPolicyType() {
        return travelPolicyType;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public String getSource() {
        return source;
    }

    public Long getAccountId() {
        return accountId;
    }

    public Long getJourneyId() {
        return journeyId;
    }

    public Long getOrderLineId() {
        return orderLineId;
    }

    public String toTokenGeneration() {
        final StringBuilder stringBuilder = new StringBuilder();

        Optional.ofNullable(transactionId).ifPresent(transactionId -> stringBuilder.append("transactionId=" + transactionId + "&"));
        Optional.ofNullable(hashedEmail).ifPresent(hashedEmail -> stringBuilder.append("hashedEmail=" + hashedEmail + "&"));
        Optional.ofNullable(styleCodeId).ifPresent(styleCodeId -> stringBuilder.append("styleCodeId=" + styleCodeId + "&"));
        Optional.ofNullable(emailTokenType).ifPresent(emailTokenType -> stringBuilder.append("emailTokenType=" + emailTokenType + "&"));
        Optional.ofNullable(action).ifPresent(action -> stringBuilder.append("action=" + action + "&"));
        Optional.ofNullable(emailId).ifPresent(emailId -> stringBuilder.append("emailId=" + emailId + "&"));
        Optional.ofNullable(productId).ifPresent(productId -> stringBuilder.append("productId=" + productId + "&"));
        Optional.ofNullable(campaignId).ifPresent(campaignId -> stringBuilder.append("campaignId=" + campaignId + "&"));
        Optional.ofNullable(vertical).ifPresent(vertical -> stringBuilder.append("vertical=" + vertical + "&"));
        Optional.ofNullable(productName).ifPresent(productName -> stringBuilder.append("productName=" + productName + "&"));
        Optional.ofNullable(travelPolicyType).ifPresent(travelPolicyType -> stringBuilder.append("travelPolicyType=" + travelPolicyType + "&"));
        Optional.ofNullable(emailAddress).ifPresent(emailAddress -> stringBuilder.append("emailAddress=" + emailAddress + "&"));
        Optional.ofNullable(source).ifPresent(source -> stringBuilder.append("source=" + source + "&"));
        Optional.ofNullable(accountId).ifPresent(accountId -> stringBuilder.append("accountId=" + accountId + "&"));
        Optional.ofNullable(journeyId).ifPresent(journeyId -> stringBuilder.append("journeyId=" + journeyId + "&"));
        Optional.ofNullable(orderLineId).ifPresent(orderLineId -> stringBuilder.append("orderLineId=" + orderLineId + "&"));

        return stringBuilder.deleteCharAt(stringBuilder.length() - 1).toString();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TokenRequest that = (TokenRequest) o;

        if (transactionId != null ? !transactionId.equals(that.transactionId) : that.transactionId != null)
            return false;
        if (hashedEmail != null ? !hashedEmail.equals(that.hashedEmail) : that.hashedEmail != null) return false;
        if (styleCodeId != null ? !styleCodeId.equals(that.styleCodeId) : that.styleCodeId != null) return false;
        if (emailTokenType != that.emailTokenType) return false;
        if (action != that.action) return false;
        if (emailId != null ? !emailId.equals(that.emailId) : that.emailId != null) return false;
        if (productId != null ? !productId.equals(that.productId) : that.productId != null) return false;
        if (campaignId != null ? !campaignId.equals(that.campaignId) : that.campaignId != null) return false;
        if (vertical != that.vertical) return false;
        if (productName != null ? !productName.equals(that.productName) : that.productName != null) return false;
        if (travelPolicyType != null ? !travelPolicyType.equals(that.travelPolicyType) : that.travelPolicyType != null)
            return false;
        return emailAddress != null ? emailAddress.equals(that.emailAddress) : that.emailAddress == null;

    }

    @Override
    public int hashCode() {
        int result = transactionId != null ? transactionId.hashCode() : 0;
        result = 31 * result + (hashedEmail != null ? hashedEmail.hashCode() : 0);
        result = 31 * result + (styleCodeId != null ? styleCodeId.hashCode() : 0);
        result = 31 * result + (emailTokenType != null ? emailTokenType.hashCode() : 0);
        result = 31 * result + (action != null ? action.hashCode() : 0);
        result = 31 * result + (emailId != null ? emailId.hashCode() : 0);
        result = 31 * result + (productId != null ? productId.hashCode() : 0);
        result = 31 * result + (campaignId != null ? campaignId.hashCode() : 0);
        result = 31 * result + (vertical != null ? vertical.hashCode() : 0);
        result = 31 * result + (productName != null ? productName.hashCode() : 0);
        result = 31 * result + (travelPolicyType != null ? travelPolicyType.hashCode() : 0);
        result = 31 * result + (emailAddress != null ? emailAddress.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "TokenRequest{" +
                "transactionId=" + transactionId +
                ", hashedEmail='" + hashedEmail + '\'' +
                ", styleCodeId=" + styleCodeId +
                ", emailTokenType=" + emailTokenType +
                ", action=" + action +
                ", emailId=" + emailId +
                ", productId='" + productId + '\'' +
                ", campaignId='" + campaignId + '\'' +
                ", vertical=" + vertical +
                ", productName='" + productName + '\'' +
                ", travelPolicyType='" + travelPolicyType + '\'' +
                ", emailAddress='" + emailAddress + '\'' +
                ", source='" + source + '\'' +
                ", accountId='" + accountId + '\'' +
                ", journeyId='" + journeyId + '\'' +
                ", orderLineId='" + orderLineId + '\'' +
                '}';
    }

    public static final class Builder {
        private Long transactionId;
        private String hashedEmail;
        private Integer styleCodeId;
        private EmailTokenType emailTokenType;
        private EmailTokenAction action;
        private Long emailId;
        private String productId;
        private String campaignId;
        private VerticalType vertical;
        private String productName;
        private String travelPolicyType;
        private String emailAddress;
        private String source;
        private Long accountId;
        private Long journeyId;
        private Long orderLineId;

        private Builder() {
        }

        public Builder(TokenRequest copy) {
            this.transactionId = copy.transactionId;
            this.hashedEmail = copy.hashedEmail;
            this.styleCodeId = copy.styleCodeId;
            this.emailTokenType = copy.emailTokenType;
            this.action = copy.action;
            this.emailId = copy.emailId;
            this.productId = copy.productId;
            this.campaignId = copy.campaignId;
            this.vertical = copy.vertical;
            this.productName = copy.productName;
            this.travelPolicyType = copy.travelPolicyType;
            this.emailAddress = copy.emailAddress;
            this.source = copy.source;
            this.accountId = copy.accountId;
            this.journeyId = copy.journeyId;
            this.orderLineId = copy.orderLineId;
        }

        public Builder transactionId(Long val) {
            transactionId = val;
            return this;
        }

        public Builder hashedEmail(String val) {
            hashedEmail = val;
            return this;
        }

        public Builder styleCodeId(Integer val) {
            styleCodeId = val;
            return this;
        }

        public Builder emailTokenType(EmailTokenType val) {
            emailTokenType = val;
            return this;
        }

        public Builder action(EmailTokenAction val) {
            action = val;
            return this;
        }

        public Builder emailId(Long val) {
            emailId = val;
            return this;
        }

        public Builder productId(String val) {
            productId = val;
            return this;
        }

        public Builder campaignId(String val) {
            campaignId = val;
            return this;
        }

        public Builder vertical(VerticalType val) {
            vertical = val;
            return this;
        }

        public Builder productName(String val) {
            productName = val;
            return this;
        }

        public Builder travelPolicyType(String val) {
            travelPolicyType = val;
            return this;
        }

        public Builder emailAddress(String val) {
            emailAddress = val;
            return this;
        }

        public Builder source(String val) {
            source = val;
            return this;
        }

        public Builder accountId(Long val) {
            accountId = val;
            return this;
        }

        public Builder journeyId(Long val) {
            journeyId = val;
            return this;
        }

        public Builder orderLineId(Long val) {
            orderLineId = val;
            return this;
        }

        public Builder setProperty(final String propertyName, final String propertyValue) {
            switch (propertyName.toLowerCase()) {
                case "transactionid":
                    transactionId(Long.valueOf(propertyValue));
                    break;
                case "hashedemail":
                    hashedEmail(propertyValue);
                    break;
                case "stylecodeid":
                    styleCodeId(Integer.valueOf(propertyValue));
                    break;
                case "emailtokentype":
                    emailTokenType(EmailTokenType.find(propertyValue));
                    break;
                case "action":
                    action(EmailTokenAction.find(propertyValue));
                    break;
                case "emailid":
                    emailId(Long.valueOf(propertyValue));
                    break;
                case "productid":
                    productId(propertyValue);
                    break;
                case "campaignid":
                    campaignId(propertyValue);
                    break;
                case "vertical":
                    vertical(VerticalType.findByCode(propertyValue));
                    break;
                case "productname":
                    productName(propertyValue);
                    break;
                case "travelpolicytype":
                    travelPolicyType(propertyValue);
                    break;
                case "emailaddress":
                    emailAddress(propertyValue);
                    break;
                case "source":
                    source(propertyValue);
                    break;
                case "accountId":
                    accountId(NumberUtils.toLong(propertyValue));
                    break;
                case "journeyId":
                    journeyId(NumberUtils.toLong(propertyValue));
                    break;
                case "orderLineId":
                    orderLineId(NumberUtils.toLong(propertyValue));
                    break;
                default:
                    throw new IllegalArgumentException("Unknown property");
            }
            return this;
        }

        public TokenRequest build() {
            return new TokenRequest(this);
        }
    }
}