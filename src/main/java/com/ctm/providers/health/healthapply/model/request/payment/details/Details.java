package com.ctm.providers.health.healthapply.model.request.payment.details;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Details {

    @JsonSerialize(using = LocalDateSerializer.class)
    private final LocalDate startDate;

    private final PaymentType paymentType;

    private final Frequency frequency;

    private final Rebate rebate;

    @JsonSerialize(using = TypeSerializer.class)
    private final Income income;

    @JsonSerialize(using = TypeSerializer.class)
    private final LifetimeHealthCoverLoading lifetimeHealthCoverLoading;

    public Details(final LocalDate startDate, final PaymentType paymentType, final Frequency frequency,
                   final Rebate rebate, final Income income, final LifetimeHealthCoverLoading lifetimeHealthCoverLoading) {
        this.startDate = startDate;
        this.paymentType = paymentType;
        this.frequency = frequency;
        this.rebate = rebate;
        this.income = income;
        this.lifetimeHealthCoverLoading = lifetimeHealthCoverLoading;
    }
}
