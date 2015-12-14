package com.ctm.web.health.apply.model.request.payment.credit;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.ctm.web.health.apply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class GatewayCreditCard {

    @JsonProperty("type")
    @JsonSerialize(using = TypeSerializer.class)
    private final Type creditCardType;

    @JsonProperty("name")
    @JsonSerialize(using = TypeSerializer.class)
    private final Name creditCardName;

    @JsonProperty(value = "number")
    @JsonSerialize(using = TypeSerializer.class)
    private final Number creditCardNumber;

    private final Expiry expiry;

    @JsonSerialize(using = TypeSerializer.class)
    private final CRN crn;

    public GatewayCreditCard(Type creditCardType, Name creditCardName, Number creditCardNumber, Expiry expiry, CRN crn) {
        this.creditCardType = creditCardType;
        this.creditCardName = creditCardName;
        this.creditCardNumber = creditCardNumber;
        this.expiry = expiry;
        this.crn = crn;
    }

    public Type getCreditCardType() {
        return creditCardType;
    }

    public Name getCreditCardName() {
        return creditCardName;
    }

    public Number getCreditCardNumber() {
        return creditCardNumber;
    }

    public Expiry getExpiry() {
        return expiry;
    }

    public CRN getCrn() {
        return crn;
    }
}
