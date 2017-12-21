package com.ctm.web.email.integration.emailservice;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel
@JsonInclude(JsonInclude.Include.ALWAYS)
public class TokenResponse {
    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonSerialize
    @JsonDeserialize
    private Long transactionId;

    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonSerialize
    @JsonDeserialize
    private Long journeyId;

    @ApiModelProperty(dataType = "java.lang.Long")
    @JsonSerialize
    @JsonDeserialize
    private Long orderLineId;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonSerialize
    @JsonDeserialize
    private String vertical;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonSerialize
    @JsonDeserialize
    private String token;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonSerialize
    @JsonDeserialize
    private String action;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonSerialize
    @JsonDeserialize
    private String url;

    @ApiModelProperty(dataType = "java.lang.String")
    @JsonSerialize
    @JsonDeserialize
    private String errorMessage;

    /* Jackson Deserialization */
    private TokenResponse() {}

    private TokenResponse(Builder builder) {
        transactionId = builder.transactionId;
        journeyId = builder.journeyId;
        orderLineId = builder.orderLineId;
        vertical = builder.vertical;
        token = builder.token;
        action = builder.action;
        url = builder.url;
        errorMessage = builder.errorMessage;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    @JsonIgnore
    public Long getTransactionId() {
        return transactionId;
    }

    @JsonIgnore
    public Long getJourneyId() {
        return journeyId;
    }

    @JsonIgnore
    public Long getOrderLineId() {
        return orderLineId;
    }

    @JsonIgnore
    public String getVertical() {
        return vertical;
    }

    @JsonIgnore
    public String getToken() {
        return token;
    }

    @JsonIgnore
    public String getUrl() {
        return url;
    }

    @JsonIgnore
    public String getErrorMessage() {
        return errorMessage;
    }

    @JsonIgnore
    public String getAction() {
        return action;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TokenResponse that = (TokenResponse) o;

        if (token != null ? !token.equals(that.token) : that.token != null) return false;
        if (action != null ? !action.equals(that.action) : that.action != null) return false;
        if (url != null ? !url.equals(that.url) : that.url != null) return false;
        return errorMessage != null ? errorMessage.equals(that.errorMessage) : that.errorMessage == null;

    }

    @Override
    public int hashCode() {
        int result = transactionId != null ? transactionId.hashCode() : 0;
        result = 31 * result + (token != null ? token.hashCode() : 0);
        result = 31 * result + (action != null ? action.hashCode() : 0);
        result = 31 * result + (url != null ? url.hashCode() : 0);
        result = 31 * result + (errorMessage != null ? errorMessage.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "TokenResponse{" +
                "transactionId=" + transactionId +
                ", journeyId=" + journeyId +
                ", orderLineId=" + orderLineId +
                ", vertical=" + vertical +
                ", token='" + token + '\'' +
                ", action='" + action + '\'' +
                ", url='" + url + '\'' +
                ", errorMessage='" + errorMessage + '\'' +
                '}';
    }

    public static final class Builder {
        private Long transactionId;
        private Long journeyId;
        private Long orderLineId;
        private String vertical;
        private String token;
        private String action;
        private String url;
        private String errorMessage;

        private Builder() {
        }

        public Builder transactionId(Long val) {
            transactionId = val;
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

        public Builder vertical(String val) {
            vertical = val;
            return this;
        }

        public Builder token(String val) {
            token = val;
            return this;
        }

        public Builder action(String val) {
            action = val;
            return this;
        }

        public Builder url(String val) {
            url = val;
            return this;
        }

        public Builder errorMessage(String val) {
            errorMessage = val;
            return this;
        }

        public TokenResponse build() {
            return new TokenResponse(this);
        }
    }
}