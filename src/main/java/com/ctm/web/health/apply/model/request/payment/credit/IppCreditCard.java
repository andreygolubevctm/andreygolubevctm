package com.ctm.web.health.apply.model.request.payment.credit;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.ctm.web.health.apply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class IppCreditCard {

    @JsonProperty("type")
    @JsonSerialize(using = TypeSerializer.class)
    private final Type creditCardType;

    @JsonProperty("name")
    @JsonSerialize(using = TypeSerializer.class)
    private final Name creditCardName;

    @JsonProperty("maskedNumber")
    @JsonSerialize(using = TypeSerializer.class)
    private final Number creditCardMaskedNumber;

    @JsonSerialize(using = TypeSerializer.class)
    private Token token;

    private final Expiry expiry;

    public IppCreditCard(final Type creditCardType, final Name creditCardName, final Number creditCardMaskedNumber, final Token token, final Expiry expiry) {
        this.creditCardType = creditCardType;
        this.creditCardName = creditCardName;
        this.creditCardMaskedNumber = creditCardMaskedNumber;
        this.token = token;
        this.expiry = expiry;
    }

    public Type getCreditCardType() {
        return creditCardType;
    }

    public Name getCreditCardName() {
        return creditCardName;
    }

    public Number getCreditCardMaskedNumber() {
        return creditCardMaskedNumber;
    }

    public Token getToken() {
        return token;
    }

    public Expiry getExpiry() {
        return expiry;
    }

}
