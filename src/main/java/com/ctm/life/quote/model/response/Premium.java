package com.ctm.life.quote.model.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.math.BigDecimal;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Premium {

    private BigDecimal value;

    @SuppressWarnings("unused")
    private Premium() {
    }

    private Premium(Builder builder) {
        value = builder.value;
    }

    public BigDecimal getValue() {
        return value;
    }


    public static final class Builder {
        private BigDecimal value;


        public Builder value(BigDecimal val) {
            value = val;
            return this;
        }


        public Premium build() {
            return new Premium(this);
        }
    }
}
