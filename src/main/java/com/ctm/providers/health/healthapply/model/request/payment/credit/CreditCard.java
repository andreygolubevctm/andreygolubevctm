package com.ctm.providers.health.healthapply.model.request.payment.credit;

import com.ctm.healthapply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

public class CreditCard {

    @JsonProperty("type")
    private Type creditCardType;
    @JsonProperty("name")
    private Name creditCardName;
    @JsonProperty("number")
    private Number creditCardNumber;

    private Expiry expiry;

    private CCV ccv;


    public Optional<Expiry> getExpiry() {
        return Optional.ofNullable(expiry);
    }

    public Optional<CCV> getCcv() {
        return Optional.ofNullable(ccv);
    }

    public Optional<Name> getCreditCardName() {
        return Optional.ofNullable(creditCardName);
    }

    public Optional<Number> getCreditCardNumber() {
        return Optional.ofNullable(creditCardNumber);
    }

    public Optional<Type> getCreditCardType() {
        return Optional.ofNullable(creditCardType);
    }

    @JsonProperty("ccv")
    private Integer ccv() {
        return getCcv().orElse(CCV.instanceOf(0)).get();
    }

    @JsonProperty("type")
    private String type() {
        return getCreditCardType().orElse(Type.instanceOf("")).get();
    }

    @JsonProperty("name")
    private String name() {
        return getCreditCardName().orElse(Name.instanceOf("")).get();
    }

    @JsonProperty("number")
    private String number() {
        return getCreditCardNumber().orElse(Number.instanceOf("")).get();
    }
}
