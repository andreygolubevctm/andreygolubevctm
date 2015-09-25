package com.ctm.providers.health.healthapply.model.request.payment.credit;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class CreditCard {

    @JsonProperty("type")
    @JsonSerialize(using = TypeSerializer.class)
    private final Type creditCardType;

    @JsonProperty("name")
    @JsonSerialize(using = TypeSerializer.class)
    private final Name creditCardName;

    @JsonProperty("number")
    @JsonSerialize(using = TypeSerializer.class)
    private final Number creditCardNumber;

    private final Expiry expiry;

    @JsonSerialize(using = TypeSerializer.class)
    private final CCV ccv;

    public CreditCard(final Type creditCardType, final Name creditCardName, final Number creditCardNumber, final Expiry expiry, final CCV ccv) {
        this.creditCardType = creditCardType;
        this.creditCardName = creditCardName;
        this.creditCardNumber = creditCardNumber;
        this.expiry = expiry;
        this.ccv = ccv;
    }



}
