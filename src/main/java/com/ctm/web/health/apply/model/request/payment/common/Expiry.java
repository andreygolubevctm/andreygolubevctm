package com.ctm.web.health.apply.model.request.payment.common;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Expiry {

    @JsonProperty("cardExpiryDay")
    @JsonSerialize(using = TypeSerializer.class)
    private final ExpiryDay cardExpiryDay;

    @JsonProperty("cardExpiryMonth")
    @JsonSerialize(using = TypeSerializer.class)
    private final ExpiryMonth cardExpiryMonth;

    @JsonProperty("cardExpiryYear")
    @JsonSerialize(using = TypeSerializer.class)
    private final ExpiryYear cardExpiryYear;

    public Expiry(final ExpiryDay cardExpiryDay, final ExpiryMonth cardExpiryMonth, final ExpiryYear cardExpiryYear) {
        this.cardExpiryDay = cardExpiryDay;
        this.cardExpiryMonth = cardExpiryMonth;
        this.cardExpiryYear = cardExpiryYear;
    }

    public Expiry(final ExpiryMonth cardExpiryMonth, final ExpiryYear cardExpiryYear) {
        this(new ExpiryDay(null), cardExpiryMonth,cardExpiryYear);
    }

    public ExpiryDay getCardExpiryDay() { return cardExpiryDay; }

    public ExpiryMonth getCardExpiryMonth() {
        return cardExpiryMonth;
    }

    public ExpiryYear getCardExpiryYear() {
        return cardExpiryYear;
    }
}
